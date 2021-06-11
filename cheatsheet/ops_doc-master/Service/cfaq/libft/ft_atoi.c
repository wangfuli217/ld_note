/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/07 20:56:18 by meassas           #+#    #+#             */
/*   Updated: 2016/11/20 20:40:05 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

int		ft_atoi(const char *nptr)
{
	int res;
	int neg;
	int i;

	i = 0;
	neg = 1;
	res = 0;
	while ((nptr[i] == ' ' || nptr[i] == '\r' || nptr[i] == '\f'
			|| nptr[i] == '\v' || nptr[i] == '\t' || nptr[i] == '\n')
		&& nptr[i])
		i++;
	neg = (nptr[i] == '-' ? -1 : 1);
	if (nptr[i] == '-' || nptr[i] == '+')
		i++;
	while (nptr[i] >= '0' && nptr[i] <= '9' && nptr[i])
	{
		res *= 10;
		res += nptr[i] - '0';
		i++;
	}
	return (neg * res);
}
