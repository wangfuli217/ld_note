/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strndup.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/23 18:53:38 by meassas           #+#    #+#             */
/*   Updated: 2016/11/23 19:02:56 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char		*ft_strndup(const char *s1, size_t n)
{
	int		i;
	char	*s2;
	size_t	j;

	j = 0;
	i = 0;
	if ((!(s2 = (char*)malloc(sizeof(char) * n + 1))))
		return (NULL);
	while (s1[i] && j < n)
		s2[j++] = s1[i++];
	s2[i] = '\0';
	return (s2);
}
