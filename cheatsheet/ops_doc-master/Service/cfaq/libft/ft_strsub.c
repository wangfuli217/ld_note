/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strsub.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/13 18:53:42 by meassas           #+#    #+#             */
/*   Updated: 2016/11/23 17:02:04 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char		*ft_strsub(char const *s, unsigned int start, size_t len)
{
	char	*s1;
	char	*s2;
	size_t	i;
	size_t	j;

	j = 0;
	s1 = (char*)s;
	i = (size_t)start;
	if (!(s))
		return (NULL);
	if (!(s2 = (char*)malloc(sizeof(char) * len + 1)))
		return (NULL);
	while (s1[i] && j < len)
		s2[j++] = s1[i++];
	s2[j] = '\0';
	return (s2);
}
