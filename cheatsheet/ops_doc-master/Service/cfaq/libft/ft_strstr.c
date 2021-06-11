/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strstr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/07 19:39:35 by meassas           #+#    #+#             */
/*   Updated: 2016/11/22 21:11:36 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strstr(const char *s1, const char *s2)
{
	int i;
	int j;
	int k;

	i = 0;
	k = 0;
	j = 0;
	if (s2[0] == '\0')
		return ((char*)s1);
	while (s1[i] && s2[j])
	{
		k = i;
		j = 0;
		while (s1[k] == s2[j])
		{
			if (s2[j + 1] == '\0')
				return ((char*)&s1[i]);
			k++;
			j++;
		}
		i++;
	}
	return (NULL);
}
