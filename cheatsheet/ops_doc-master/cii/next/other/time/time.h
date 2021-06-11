#define RTC_CLK_FREQ		(38000/32)//

/**
 * @name    Time conversion utilities
 * @{
 */
/**
 * @brief   Seconds to system ticks.
 * @details Converts from seconds to system ticks number.
 * @note    The result is rounded upward to the next tick boundary.
 *
 * @param[in] sec       number of seconds
 * @return              The number of ticks.
 *
 * @api
 */
#define S2ST(sec)                                                           \
  ((u_long)((u_long)(sec) * (u_long)RTC_CLK_FREQ))

/**
 * @brief   Milliseconds to system ticks.
 * @details Converts from milliseconds to system ticks number.
 * @note    The result is rounded upward to the next tick boundary.
 *
 * @param[in] msec      number of milliseconds
 * @return              The number of ticks.
 *
 * @api
 */
#define MS2ST(msec)                                                      \
  ((u_long)(((((u_long)(msec)) *                                       \
                 ((u_long)RTC_CLK_FREQ)) + 999UL) / 1000UL))


/**
 * @brief   Microseconds to system ticks.
 * @details Converts from microseconds to system ticks number.
 * @note    The result is rounded upward to the next tick boundary.
 *
 * @param[in] usec      number of microseconds
 * @return              The number of ticks.
 *
 * @api
 */
#define US2ST(usec)                                                      \
  ((u_long)(((((u_long)(usec)) *                                       \
                 ((u_long)RTC_CLK_FREQ)) + 999999UL) / 1000000UL))
