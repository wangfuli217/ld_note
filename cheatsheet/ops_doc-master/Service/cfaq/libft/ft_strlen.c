/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlen.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/07 18:49:17 by meassas           #+#    #+#             */
/*   Updated: 2016/11/20 20:55:31 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

size_t				ft_strlen(const char *str)
{
	size_t			len;
	unsigned char	*str2;

	str2 = (unsigned char*)str;
	len = 0;
	while (str2[len])
		len++;
	return (len);
}
