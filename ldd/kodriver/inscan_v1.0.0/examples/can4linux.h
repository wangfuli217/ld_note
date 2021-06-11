/*
 * can4linux.h - advcan CAN driver module
 *
 */


#ifndef __CAN_H
#define __CAN_H


# define CAN4LINUXVERSION 0x0304 /*(Version 3.3)*/

#ifndef __KERNEL__
#include <sys/time.h>
#endif
 /*---------- the can message structure */

#define CAN_MSG_LENGTH 8		/**< maximum length of a CAN frame */


#define MSG_RTR		(1<<0)		/**< RTR Message */
#define MSG_OVR		(1<<1)		/**< CAN controller Msg overflow error */
#define MSG_EXT		(1<<2)		/**< extended message format */
#define MSG_SELF	(1<<3)		/**< message received from own tx */
#define MSG_PASSIVE	(1<<4)		/**< controller in error passive */
#define MSG_BUSOFF      (1<<5)		/**< controller Bus Off  */
#define MSG_WARNING     (1<<6)		/**< CAN Warning Level reached */
#define MSG_BOVR	(1<<7)		/**< receive/transmit buffer overflow */
/**
* mask used for detecting CAN errors in the canmsg_t flags field
*/
#define MSG_ERR_MASK	(MSG_OVR + MSG_PASSIVE + MSG_BUSOFF + MSG_BOVR)

/**
* The CAN message structure.
* Used for all data transfers between the application and the driver
* using read() or write().
*/
typedef struct 
{
    /** flags, indicating or controlling special message properties */
    int             flags;
    int             cob;	               /**< CAN object number, used in Full CAN  */
    unsigned   long id;		               /**< CAN message ID, 4 bytes  */
    struct timeval  timestamp;	         /**< time stamp for received messages */
    short      int  length;	            /**< number of bytes in the CAN message */
    unsigned   char data[CAN_MSG_LENGTH]; /**< data, 0...8 bytes */
} canmsg_t;



/**
---------- IOCTL requests */
/* Use 'c' as magic number, follow chapter 6 of LDD3 */
#define CAN4L_IOC_MAGIC 'c'

#define CAN_IOCTL_COMMAND 	 _IO(CAN4L_IOC_MAGIC,1)	/**< IOCTL command request */
#define CAN_IOCTL_CONFIG 	 _IO(CAN4L_IOC_MAGIC,2)	/**< IOCTL configuration request */
#define CAN_IOCTL_SEND 		 _IO(CAN4L_IOC_MAGIC,3)	/**< IOCTL request */
#define CAN_IOCTL_CONFIGURERTR 	 _IO(CAN4L_IOC_MAGIC,4)	/**< IOCTL request */
#define CAN_IOCTL_STATUS         _IO(CAN4L_IOC_MAGIC,5)      /**< IOCTL status request */
#define CAN_IOCTL_IOC_MAXNR      5

/*---------- CAN ioctl parameter types */
/**
 IOCTL Command request parameter structure */
struct Command_par {
    int cmd;               /**< special driver command */
    int target;            /**< special configuration target */
    unsigned long val1;    /**< 1. parameter for the target */
    unsigned long val2;		/**< 2. parameter for the target */
    int error;             /**< return value */
    unsigned long retval;  /**< return value */
};



/* IOCTL Command request parameter structure */
typedef struct Command_par Command_par_t ; /**< Command parameter struct */

/* IOCTL CConfiguration request parameter structure */
typedef struct Command_par  Config_par_t ; /**< Configuration parameter struct */



/* IOCTL generic CAN controller status request parameter structure */
typedef struct CanStatusPar { 
    unsigned int   baud;                  /**< actual bit rate */
    unsigned int   status;		            /**< CAN controller status register */
    unsigned int   error_warning_limit;	/**< the error warning limit */
    unsigned int   rx_errors;             /**< content of RX error counter */
    unsigned int   tx_errors;             /**< content of TX error counter */
    unsigned int   error_code;		      /**< content of error code register */
    unsigned int   rx_buffer_size;	      /**< size of rx buffer  */
    unsigned int   rx_buffer_used;	      /**< number of messages */
    unsigned int   tx_buffer_size;	      /**< size of tx buffer  */
    unsigned int   tx_buffer_used;	      /**< number of messages */
    unsigned long  retval;		            /**< return value */
    unsigned int   type;			         /**< CAN controller / driver type */
} CanStatusPar_t;

/**
 IOCTL  CanStatusPar.type CAN controller hardware chips */
#define CAN_TYPE_UNSPEC       0
#define CAN_TYPE_SJA1000      1
#define CAN_TYPE_FlexCAN      2
#define CAN_TYPE_TouCAN       3
#define CAN_TYPE_82527        4
#define CAN_TYPE_TwinCAN      5
#define CAN_TYPE_BlackFinCAN  6


/**
 IOCTL Send request parameter structure */
typedef struct Send_par {
    canmsg_t *Tx;		      /**< CAN message struct  */
    int error;             /**< return value for errno */
    unsigned long retval;	/**< return value */
} Send_par_t ;

/**
 IOCTL Receive request parameter structure */
typedef struct Receive_par {
    canmsg_t *Rx;          /**< CAN message struct  */
    int error;             /**< return value for errno */
    unsigned long retval;  /**< return value */
} Receive_par_t ;

/**
IOCTL ConfigureRTR request parameter structure */
typedef struct ConfigureRTR_par {
    unsigned message;      /**< CAN message ID */
    canmsg_t *Tx;          /**< CAN message struct  */
    int error;             /**< return value for errno */
    unsigned long retval;  /**< return value */
} ConfigureRTR_par_t ;

/**
---------- IOCTL Command subcommands and there targets */

# define CMD_START         1
# define CMD_STOP          2
# define CMD_RESET         3
# define CMD_CLEARBUFFERS  4




/**
---------- IOCTL Configure targets */

# define CONF_ACC                0  /* mask and code */
# define CONF_ACCM               1  /* mask only */
# define CONF_ACCC               2  /* code only */
# define CONF_TIMING             3  /* bit timing */
# define CONF_OMODE              4  /* output control register */
# define CONF_FILTER	            5
# define CONF_FENABLE	         6
# define CONF_FDISABLE	         7
# define CONF_LISTEN_ONLY_MODE	8  /* for SJA1000 PeliCAN */
# define CONF_SELF_RECEPTION	   9
# define CONF_BTR                10 /* set direct bit timing registers(SJA1000) */
# define CONF_TIMESTAMP          11 /* use TS in received messages */
# define CONF_WAKEUP             12 /* wake up processes */

#endif 	/* __CAN_H */
