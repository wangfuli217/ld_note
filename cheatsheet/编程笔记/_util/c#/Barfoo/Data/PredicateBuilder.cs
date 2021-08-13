using System;
using System.Text;
using System.Linq;
using System.Collections.Generic;
using System.Linq.Expressions;

using Barfoo.Library.Serialization;

namespace Barfoo.Library.Data
{
    /// <summary>
    /// LinQ 的扩展,方便动态组织查询条件
    /// </summary>
    public static class PredicateBuilder
    {
        /// <summary>
        /// 动态查询条件创建者
        /// <![CDATA[
        ///     var builder = PredicateBuilder.Create<Company>();
        ///     builder = builder.Equals(p => p.DepartmentId, 55);
        ///     builder = builder.Between(p => p.AddOn, 0, 100);
        ///     builder.And(p => p.CityId > 0);
        ///     Company company = new CompanyDbLogic().GetObject(builder.Expression);
        /// ]]>
        /// </summary>
        /// <typeparam name="T">实体数据类型</typeparam>
        public static IQueryBuilder<T> Create<T>()
        {
            return new QueryBuilder<T>();
        }

        public static Expression<Func<TSource, bool>> True<TSource>()
        {
            return f => true;
        }

        public static Expression<Func<TSource, bool>> False<TSource>()
        {
            return f => false;
        }

        public static Expression<Func<TSource, bool>> Or<TSource>
            (this Expression<Func<TSource, bool>> expr1, Expression<Func<TSource, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
            return Expression.Lambda<Func<TSource, bool>>(Expression.Or(expr1.Body, invokedExpr), expr1.Parameters);
        }

        public static Expression<Func<TSource, bool>> And<TSource>
            (this Expression<Func<TSource, bool>> expr1, Expression<Func<TSource, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
            return Expression.Lambda<Func<TSource, bool>>(Expression.And(expr1.Body, invokedExpr), expr1.Parameters);
        }
    }


    /// <summary>
    /// 动态查询条件储存者
    /// </summary>
    /// <typeparam name="T">实体数据类型</typeparam>
    public interface IQueryBuilder<T>
    {
        Expression<Func<T, bool>> Expression { get; set; }
    }
    class QueryBuilder<T> : IQueryBuilder<T>
    {
        private Expression<Func<T, bool>> predicate;
        Expression<Func<T, bool>> IQueryBuilder<T>.Expression
        {
            get { return predicate; }
            set { predicate = value; }
        }

        public QueryBuilder()
        {
            predicate = PredicateBuilder.True<T>();
        }
    }

    public static class IQueryBuilderExtensions
    {
        /// <summary>
        /// 建立 Equals ( 相等 ) 查询条件
        /// </summary>
        /// <typeparam name="T">实体</typeparam>
        /// <param name="q">动态查询条件创建者</param>
        /// <param name="property">属性</param>
        /// <param name="value">查询值</param>
        /// <returns></returns>
        public static IQueryBuilder<T> And<T>(this IQueryBuilder<T> q, Expression<Func<T, bool>> property)
        {
            q.Expression = q.Expression.And(property);
            return q;
        }

        /// <summary>
        /// 建立 Equals ( 相等 ) 查询条件
        /// </summary>
        /// <typeparam name="T">实体</typeparam>
        /// <param name="q">动态查询条件创建者</param>
        /// <param name="property">属性</param>
        /// <param name="value">查询值</param>
        /// <returns></returns>
        public static IQueryBuilder<T> Equals<T, P>(this IQueryBuilder<T> q, Expression<Func<T, P>> property, P value)
        {
            var parameter = property.GetParameters();
            var constant = Expression.Constant(value);
            Type type = typeof(P);
            Expression nonNullProperty = property.Body;

            //如果是Nullable<X>类型，则转化成X类型
            if (IsNullableType(type))
            {
                type = GetNonNullableType(type);
                nonNullProperty = Expression.Convert(property.Body, type);
            }

            var methodExp = Expression.Equal(nonNullProperty, constant);
            Expression<Func<T, bool>> lambda = Expression.Lambda<Func<T, bool>>(methodExp, parameter);
            q.Expression = q.Expression.And(lambda);
            return q;
        }

        /// <summary>
        /// 建立 Between 查询条件
        /// </summary>
        /// <typeparam name="T">实体</typeparam>
        /// <param name="q">动态查询条件创建者</param>
        /// <param name="property">属性</param>
        /// <param name="from">开始值</param>
        /// <param name="to">结束值</param>
        /// <returns></returns>
        public static IQueryBuilder<T> Between<T, P>(this IQueryBuilder<T> q, Expression<Func<T, P>> property, P from, P to)
        {
            var parameter = property.GetParameters();
            var constantFrom = Expression.Constant(from);
            var constantTo = Expression.Constant(to);
            Type type = typeof(P);

            Expression nonNullProperty = property.Body;
            //如果是Nullable<X>类型，则转化成X类型
            if (IsNullableType(type))
            {
                type = GetNonNullableType(type);
                nonNullProperty = Expression.Convert(property.Body, type);
            }

            var c1 = Expression.GreaterThanOrEqual(nonNullProperty, constantFrom);
            var c2 = Expression.LessThanOrEqual(nonNullProperty, constantTo);
            var c = Expression.AndAlso(c1, c2);
            Expression<Func<T, bool>> lambda = Expression.Lambda<Func<T, bool>>(c, parameter);

            q.Expression = q.Expression.And(lambda);
            return q;
        }

        /// <summary>
        /// 建立 In 查询条件
        /// </summary>
        /// <typeparam name="T">实体</typeparam>
        /// <param name="q">动态查询条件创建者</param>
        /// <param name="property">属性</param>
        /// <param name="valuse">查询值</param>
        /// <returns></returns>
        public static IQueryBuilder<T> In<T, P>(this IQueryBuilder<T> q, Expression<Func<T, P>> property, params P[] values)
        {
            if (values != null && values.Length > 0)
            {
                var parameter = property.GetParameters();
                var constant = Expression.Constant(values);
                Type type = typeof(P);
                Expression nonNullProperty = property.Body;
                //如果是Nullable<X>类型，则转化成X类型
                if (IsNullableType(type))
                {
                    type = GetNonNullableType(type);
                    nonNullProperty = Expression.Convert(property.Body, type);
                }

                Expression<Func<P[], P, bool>> InExpression = (list, el) => list.Contains(el);
                var methodExp = InExpression;
                var invoke = Expression.Invoke(methodExp, constant, property.Body);
                Expression<Func<T, bool>> lambda = Expression.Lambda<Func<T, bool>>(invoke, parameter);
                q.Expression = q.Expression.And(lambda);
            }
            return q;
        }

        /// <summary>
        /// 建立 Like ( 模糊 ) 查询条件
        /// </summary>
        /// <typeparam name="T">实体</typeparam>
        /// <param name="q">动态查询条件创建者</param>
        /// <param name="property">属性</param>
        /// <param name="value">查询值</param>
        /// <returns></returns>
        public static IQueryBuilder<T> Like<T>(this IQueryBuilder<T> q, Expression<Func<T, string>> property, string value)
        {
            /*
            value = value.Trim();
            if (!string.IsNullOrEmpty(value))
            {
                var parameter = property.GetParameters();
                var constant = Expression.Constant("%" + value + "%");
                MethodCallExpression methodExp = Expression.Call(null, typeof(System.Data.Linq.SqlClient.SqlMethods).GetMethod("Like",
                    new Type[] { typeof(string), typeof(string) }), property.Body, constant);
                Expression<Func<T, bool>> lambda = Expression.Lambda<Func<T, bool>>(methodExp, parameter);

                q.Expression = q.Expression.And(lambda);
            }*/
            return q;
        }

        private static ParameterExpression[] GetParameters<T, S>(this Expression<Func<T, S>> expr)
        {
            return expr.Parameters.ToArray();
        }

        static bool IsNullableType(Type type)
        {
            return type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>);
        }

        static Type GetNonNullableType(Type type)
        {
            return type.GetGenericArguments()[0];
            //return IsNullableType(type) ? type.GetGenericArguments()[0] : type;
        }
    }
}
