/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_itoa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/19 20:06:10 by meassas           #+#    #+#             */
/*   Updated: 2016/11/23 16:53:32 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static char		*intmin(int n)
{
	char		*s;

	if (!(s = (char*)malloc(sizeof(char) * 12)))
		return (NULL);
	if (n == -2147483648)
	{
		s[0] = '-';
		s[1] = '2';
		s[2] = '1';
		s[3] = '4';
		s[4] = '7';
		s[5] = '4';
		s[6] = '8';
		s[7] = '3';
		s[8] = '6';
		s[9] = '4';
		s[10] = '8';
		s[11] = '\0';
	}
	return (s);
}

char			*ft_itoa(int n)
{
	int			i;
	int			len;
	char		*s;
	int			div;

	i = 0;
	len = 1;
	div = 1;
	if (n == -2147483648)
		return (intmin(n));
	if (n < 0 && (i += 1) && (len += 1))
		n *= -1;
	while (((n / div) >= 10) && (len += 1))
		div *= 10;
	if (!(s = (char*)malloc(sizeof(char) * (len + 1))))
		return (NULL);
	if (i == 1)
		s[0] = '-';
	while (div > 0)
	{
		s[i++] = ((n / div) % 10 + '0');
		div = div / 10;
	}
	s[i] = '\0';
	return (s);
}
