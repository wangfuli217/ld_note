/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_itoa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/19 20:06:10 by meassas           #+#    #+#             */
/*   Updated: 2017/04/22 08:30:00 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#define hex_conv 10

char	*ft_itoa_base(int n, int base)
{
	int			i;
	int			len;
	char		*s;
	long long int	nb;

	nb = n;
	i = 0;
	len = 0;
	if (nb < 0 && (len += 1))
		nb *= -1;
	while (((nb /= base) > 0) && (len += 1));
	s = ft_memalloc(len + 1);
	nb = (n < 0) ? (n * -1) : n;
	while (nb != 0)
	{
		if ((nb % base) >= hex_conv)
			s[i++] = (nb % base) + 87;
		else
			s[i++] = nb % base + '0';
		nb = nb / base;
	}
	ft_strrev(s);
	if (base == 10 && n < 0)
	{
		s = ft_strjoin("-", s);
		s[i + 1] = '\0';
	}
	else
		s[i] = '\0';
	return (s);
}

int		main()
{
	int n;

	n = 16;
	ft_putstr(ft_itoa_base(n, 16));
	return (0);
}
