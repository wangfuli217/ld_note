/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strchr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/07 19:31:20 by meassas           #+#    #+#             */
/*   Updated: 2016/11/23 16:10:17 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strchr(const char *str, int c)
{
	int i;

	i = 0;
	while (str[i] != c)
	{
		if ((str[i] == '\0' && (c != '\0' || c != 0xff00)))
			return (NULL);
		i++;
	}
	return ((char*)&str[i]);
}
