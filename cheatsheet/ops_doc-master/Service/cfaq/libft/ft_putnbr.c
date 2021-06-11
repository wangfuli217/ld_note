/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putnbr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/13 21:26:56 by meassas           #+#    #+#             */
/*   Updated: 2017/04/22 04:28:13 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void			ft_putnbr(int n)
{
    int			div;
    long int	nb;

    div = 1;
    nb = n;
    if (nb < 0)
    {
        ft_putchar('-');
        nb *= -1;
    }
    while ((nb / div) >= 10)
    div *= 10;
    while (div > 0)
    {
        ft_putchar((nb / div) % 10 + 48);
        div /= 10;
    }
    ft_putchar('\n');
}
