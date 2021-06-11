#ifndef _CONFIG_H_
#define _CONFIG_H_

#define SORDRELEASE "sord  version : 1.0.1  wangfl@www.xianleidi.com build at 2019-12-03_01:56:50 PM"
#define HOSTRELEASE "hostd  version : 1.0.1  wangfl@www.xianleidi.com build at 2019-12-03_01:56:50 PM"
#define SLOTRELEASE "slotd  version : 1.0.1  wangfl@www.xianleidi.com build at 2019-12-03_01:56:50 PM"
#define OTDRRELEASE "otdrd  version : 1.0.1  wangfl@www.xianleidi.com build at 2019-12-03_01:56:50 PM"
#define RTUDRELEASE "rtud  version : 1.0.1  wangfl@www.xianleidi.com build at 2019-12-03_01:56:50 PM"

typedef struct system_time
{
    uint16_t year;
    uint8_t mon;
    uint8_t day;
    uint8_t hour;
    uint8_t min;
    uint8_t sec;
    uint8_t wsec;
} system_time;


#define INET_ADDRSTRLEN         16
#define RTU_REPORT_ADDR_MAX     4

//rtu alarm default bell
#define DEFAULT_RTU_BELL_STATE  0

//otdr curvedata (threshold)

#define DEFAULT_SMPINF_SAMPBLES_ABS  2
#define DEFAULT_SMPINF_PRECISION_ABS 2

#define DEFAULT_AUT_ENV2_ABS         2
#define DEFAULT_AUT_LOSS_ABS         2
#define DEFAULT_AUT_RLOSS_ABS        2

#define DEFAULT_EVN2_LOSS_N_ABS      2
#define DEFAULT_EVN2_REFLACT_N_ABS   2
#define DEFAULT_EVN2_TLOSS_N_ABS     2

#define DEFAULT_EVN2_LOSS_O_ABS      2
#define DEFAULT_EVN2_REFLACT_O_ABS   2
#define DEFAULT_EVN2_TLOSS_O_ABS     2

#define DEFAULT_EVN2_LOSS_R_ABS      2
#define DEFAULT_EVN2_REFLACT_R_ABS   2
#define DEFAULT_EVN2_TLOSS_R_ABS     2

#define DEFAULT_EVN2_LOSS_S_ABS      2
#define DEFAULT_EVN2_REFLACT_S_ABS   2
#define DEFAULT_EVN2_TLOSS_S_ABS     2

#define DEFAULT_EVN2_LOSS_E_ABS      2
#define DEFAULT_EVN2_REFLACT_E_ABS   2
#define DEFAULT_EVN2_TLOSS_E_ABS     2



//rtu monitor module (file desc)
#define DEFAULT_RTU_LED_RUN_PATH        "/proc/rtu_status/run"
#define DEFAULT_RTU_LED_LINK_PATH       "/proc/rtu_status/link"
#define DEFAULT_RTU_INPUT_MASK_PATH     "/proc/rtu_status/mask"
#define DEFAULT_RTU_ALARM_BELL_PATH     "/proc/rtu_status/bell"
#define DEFAULT_RTU_CARD_PLUG_PATH      "/proc/rtu_status/plug"
#define DEFAULT_RTU_OPM_STATUS_PATH     "/proc/rtu_status/opm"
#define DEFAULT_RTU_PWR1_STATUS_PATH    "/proc/rtu_status/power1"
#define DEFAULT_RTU_PWR2_STATUS_PATH    "/proc/rtu_status/power2"

//rtu report server port
#define DEFAULT_RTU_REPORT_PORT     5000
#define DEFAULT_RTU_REPORT_ADDR1    "*"
#define DEFAULT_RTU_REPORT_ADDR2    "*"
#define DEFAULT_RTU_REPORT_ADDR3    "*"
#define DEFAULT_RTU_REPORT_ADDR4    "*"


//rtu support max fibre
#define DEFAULT_RTU_FIBRE_MAX       64
#define DEFAULT_RTU_CURVEDATA_MAX   10

//rtu configuration
#define DEFAULT_RTU_CONFIG_PATH     "/etc/rtud/"
#define DEFAULT_OPM_CONFIG_PATH     "/etc/rtud/opm/"
#define DEFAULT_FIBER_CONFIG_PATH   "/etc/rtud/fibre/"
#define DEFAULT_FIBER_PERIOD_PATH   "/etc/rtud/period/"
#define DEFAULT_OSL_CONFIG_PATH     "/etc/rtud/osl/"
#define DEFAULT_CURVE_DATA_PATH     "/etc/rtud/curvedata/"

// tty configuration
#define DEFAULT_RTU_TTY_NAME                "/dev/ttyS0"
#define DEFAULT_RTU_TTY_BAUDRATE            57600L
#define DEFAULT_RTU_TTY_DATA_BIT            8u
#define DEFAULT_RTU_TTY_STOP_BIT            1u
#define DEFAULT_RTU_TTY_PARITY_BIT          "n"
//tty scan period 10 second 
#define DEFAULT_RTU_TTY_SCAN_PERIOD         4

//tty power slot and fan slot
#define DEFAULT_RTU_TTY_MCU_SLOT            15
#define DEFAULT_RTU_TTY_POWER1_SLOT         16
#define DEFAULT_RTU_TTY_POWER2_SLOT         17
#define DEFAULT_RTU_TTY_FAN_SLOT            18
#define DEFAULT_RTU_TTY_SLOT_MAX            18

#define DEFAULT_RTU_TTY_POWER1_SERIAL       "01010010125001"
#define DEFAULT_RTU_TTY_POWER1_HVER         "A1"
#define DEFAULT_RTU_TTY_POWER1_SVER         "1.0.0.0"

#define DEFAULT_RTU_TTY_POWER2_SERIAL       "01010010125001"
#define DEFAULT_RTU_TTY_POWER2_HVER         "A1"
#define DEFAULT_RTU_TTY_POWER2_SVER         "1.0.0.0"

#define DEFAULT_RTU_TTY_FAN_SERIAL          "01010010125001"
#define DEFAULT_RTU_TTY_FAN_HVER            "A1"
#define DEFAULT_RTU_TTY_FAN_SVER            "1.0.0.0"

#define DEFAULT_RTU_TTY_MCU_SERIAL          "01010010125001"
#define DEFAULT_RTU_TTY_MCU_HVER            "A1"
#define DEFAULT_RTU_TTY_MCU_SVER            "1.0.0.0"

//otdr TCP connect
#define DEFAULT_OTDR_SERVER_IP              "192.168.0.252"
#define DEFAULT_OTDR_SERVER_NETMASK         "255.255.255.0"
#define DEFAULT_OTDR_SERVER_GATEWAY         "192.168.0.1"
#define DEFAULT_OTDR_SERVER_PORT            "8000"

#define DEFAULT_OTDR_GETFILE_REPORT         1

//ODTR parameter value
#define DEFAULT_ODTR_WLS_VAL            1625
#define DEFAULT_ODTR_ALA_MOD            1
#define DEFAULT_ODTR_ALA_VAL            5
#define DEFAULT_ODTR_AVG_MOD            1
#define DEFAULT_ODTR_STP_DISTANCE_MOD   0
#define DEFAULT_ODTR_STP_DISTANCE_VAL   500
#define DEFAULT_ODTR_STP_PULSE_MOD      0
#define DEFAULT_ODTR_STP_PULSE_VAL      5
#define DEFAULT_ODTR_STP_MOD            0

#define DEFAULT_ODTR_THS_VAL            0.05
#define DEFAULT_ODTR_THR2_VAL           -40
#define DEFAULT_ODTR_THF_VAL            5.0
#define DEFAULT_ODTR_IOR_VAL            1.476000
#define DEFAULT_ODTR_BLS2_VAL           -45.68 //not need set


//ldproxy 
#define DEFAULT_LDPROXY_SERVER_IP       "192.168.1.252"
#define DEFAULT_LDPROXY_SERVER_NETMASK  "255.255.255.0"
#define DEFAULT_LDPROXY_SERVER_GATEWAY  "192.168.1.1"
#define DEFAULT_LDPROXY_SERVER_PORT     5000

#define DEFAULT_HOST_CONFIG_RTU         ""
#define DEFAULT_MON_ALARM_LOGGER     ""

#endif
