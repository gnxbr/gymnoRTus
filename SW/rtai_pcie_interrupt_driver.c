#include <linux/module.h>
#include <linux/pci.h>
#include <linux/interrupt.h>
#include <linux/errno.h>
#include <rtai.h>
#include <rtai_sched.h>
#include <rtai_fifos.h>

#define KB  1024
#define MB  1024*KB

#define FIFO_DATA    0

// Defines addresses configured on QSys (bar0)
#define PCIE_AVALONTOP  0x0000

// Defines addresses configured on QSys (bar2)
#define PCIE_CRA        0x0000

// Defines some CRA addresses
#define CRA_INTSTAREG   0x40

// Defines for the EchoModule Interface
#define AVALONTOP_WADDR 0x00
#define AVALONTOP_RFLAG 0x00
#define AVALONTOP_WSTOP 0x04

#define DMA_BITS 32
#define DMA_SIZE (2048*sizeof(uint64_t))

static void *avalontop_base;

static uint8_t n_devices = 0;

static uint32_t epoch = 2;
static uint64_t *dma_ptr = NULL;
static dma_addr_t dma_handle;

// -------- Interrupt handler --------
static int irq_handler(unsigned irq, void *cookie_) {
    const uint32_t flag = ioread32(avalontop_base + AVALONTOP_RFLAG);
    const int irq_is_ours = (flag == epoch);

    if (likely(irq_is_ours)) {
        int i = 0, j = (flag % 2 == 0) ? 0 : 1024;

        for (; i < 1024; i++, j++)
            rtf_put(FIFO_DATA, (void*)&dma_ptr[j], sizeof(dma_ptr[0]));

        ++epoch;
    }

    rt_unmask_irq(irq);
    return irq_is_ours;
}


static struct pci_device_id pci_ids[] = {
    { PCI_DEVICE(0x1172, 0x0de4), }, // Demo numbers
    { 0, }
};
MODULE_DEVICE_TABLE(pci, pci_ids);

static int pci_probe(struct pci_dev *dev, const struct pci_device_id *id);
static void pci_remove(struct pci_dev *dev);

static struct pci_driver pci_driver = {
    .name       = "pcie_interrupt",
    .id_table   = pci_ids,
    .probe      = pci_probe,
    .remove     = pci_remove,
};

static int pci_probe(struct pci_dev *dev, const struct pci_device_id *id) {
    unsigned long resource;
    int retval;

    if(++n_devices > 1)
        return -EOVERFLOW;

    retval = pci_enable_device(dev);

    if(retval) {
        rt_printk("pcie_interrupt_driver: ERROR: Unable to enable device: %d\n",retval);
        return retval;
    }
    else
        rt_printk("pcie_interrupt_driver: device enabled!\n");

    // Allow device to master the bus (required for DMA)
    pci_set_master(dev);

    // Set coherent DMA address limitation
    retval = pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(DMA_BITS));
    if(retval) {
        rt_printk("pcie_interrupt_driver: ERROR: Unable to set DMA bit mask: %d\n", retval);
        return retval;
    }

    // Allocate a memory block suitable for coherent DMA
    dma_ptr = dma_alloc_coherent(&dev->dev, DMA_SIZE, &dma_handle, GFP_KERNEL);
    if(dma_ptr == NULL) {
        rt_printk("pcie_interrupt_driver: could not allocate memory for DMA\n");
        return -ENOMEM;
    }

    rt_printk("pcie_interrupt_driver: Allocated coherent memory: dma_handle=0x%x, ptr=%p\n", dma_handle, dma_ptr);

    // Gets a pointer to bar0
    resource = pci_resource_start(dev,0);
    avalontop_base = ioremap_nocache(resource + PCIE_AVALONTOP, 16);

    // Read vendor ID
    rt_printk("pcie_interrupt_driver: Found Vendor id: 0x%0.4x\n", dev->vendor);
    rt_printk("pcie_interrupt_driver: Found Device id: 0x%0.4x\n", dev->device);

    // Read IRQ Number
    rt_printk("pcie_interrupt_driver: Found IRQ: %d\n", dev->irq);

    // Request IRQ and install handler
    retval = rt_request_irq(dev->irq, irq_handler, NULL, 0);
    if(retval) {
        rt_printk("pcie_interrupt_driver: request_irq failed!\n");
        return retval;
    }

    rt_startup_irq(dev->irq);

    iowrite32(dma_handle, avalontop_base + AVALONTOP_WADDR);

    return 0;
}

static void pci_remove(struct pci_dev *dev) {

    rt_release_irq(dev->irq);

    --n_devices;

    if(dma_ptr != NULL)
        dma_free_coherent(&dev->dev, DMA_SIZE, dma_ptr, dma_handle);

    iounmap(avalontop_base);

    pci_set_drvdata(dev,NULL);
    rt_printk("pcie_interrupt_driver: Interrupt handler uninstalled.\n");
}

/*******************************
 *  Driver Init/Exit Functions *
 *******************************/

static int pcie_interrupt_init(void) {
    int retval;

    rtf_create(FIFO_DATA, 16*MB);

    // Register PCI Driver
    // IRQ is requested on pci_probe
    retval = pci_register_driver(&pci_driver);
    if (retval)
        rt_printk("pcie_interrupt_driver: ERROR: cannot register pci.\n");
    else
        rt_printk("pcie_interrupt_driver: pci driver registered.\n");

    return retval;
}

static void pcie_interrupt_exit(void) {
    iowrite32(0, avalontop_base + AVALONTOP_WSTOP);

    rtf_destroy(FIFO_DATA);

    pci_unregister_driver(&pci_driver);
    rt_printk("pcie_interrupt_driver: pci driver unregistered.\n");
}

module_init(pcie_interrupt_init);
module_exit(pcie_interrupt_exit);
MODULE_LICENSE("GPL");