/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strnstr.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/23 14:01:44 by meassas           #+#    #+#             */
/*   Updated: 2016/11/23 14:08:42 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strnstr(const char *s1, const char *s2, size_t len)
{
	int i;
	int j;
	int k;

	i = 0;
	k = 0;
	j = 0;
	if (ft_strlen(s1) < ft_strlen(s2))
		return (NULL);
	if (s2[0] == '\0')
		return ((char*)s1);
	while (s1[i] && s2[j])
	{
		k = i;
		j = 0;
		while (s1[k] == s2[j])
		{
			if (s2[j + 1] == '\0' && (size_t)k < len)
				return ((char*)&s1[i]);
			k++;
			j++;
		}
		i++;
	}
	return (NULL);
}
