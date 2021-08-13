using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Collections.Specialized;
using MongoDB;
using MongoDB.Configuration;

namespace Barfoo.Library.Data
{
    public class MongoDBHelper
    {
        private static Dictionary<string, string> instances = new Dictionary<string, string>();
        private static readonly string DefaultName = "default";

        /// <summary>
        /// 获取默认的实例
        /// </summary>
        /// <returns></returns>
        public static MongoDBHelper GetInstance()
        {
            return GetInstance(DefaultName);
        }

        /// <summary>
        /// 根据名字获取mongobd连接的实例
        /// 
        ///public class MyClass
        ///{
        ///    [MongoId]
        ///    public string MyID { get; set; }
        ///    public string Name { get; set; }
        ///    public int Corners { get; set; }
        ///}
        ///
        ///    var db = MongoDBHelper.GetInstance();
        ///    db.Excute("mytestqqq", process =>
        ///        {
        ///            var c = process.GetCollection<MyClass>();
        ///            var mc = new MyClass()
        ///            {
        ///                myID = "CustomID",
        ///                Name = "BarfooUser",
        ///                Corners = 1
        ///            };
        ///
        ///            c.Save(mc);
        ///            var cc = c.FindAll();
        ///
        ///            foreach (var item in cc.Documents)
        ///            {
        ///                Console.WriteLine(item.myID);
        ///                Console.WriteLine(item.Name);
        ///                Console.WriteLine(item.Corners);
        ///            }
        ///        });
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static MongoDBHelper GetInstance(string name)
        {
            var connectionString = string.Empty;
            if (instances.TryGetValue(name, out connectionString))
            {
                return new MongoDBHelper(connectionString);
            }
            else
            {
                var section = MongoConfigurationSection.GetSection();

                if (section != null
                    && section.Connections[name] != null
                    && !string.IsNullOrEmpty(section.Connections[name].ConnectionString))
                {
                    connectionString = section.Connections[name].ConnectionString;
                    instances[name] = connectionString;
                    return new MongoDBHelper(connectionString);
                }
                throw new ConfigurationErrorsException("Unable to find MongoDB instance \"" + name + "\".");
            }
        }

        private string connectionString = string.Empty;
        /// <summary>
        /// 实例化Helper
        /// </summary>
        /// <param name="connectionString">Mongodb数据库连接串</param>
        public MongoDBHelper(string connectionString)
        {
            this.connectionString = connectionString;
        }

        /// <summary>
        /// 获取Mongo连接
        /// </summary>
        /// <returns></returns>
        public IMongo GetMongoConnection()
        {
            var con = new Mongo(this.connectionString);
            
            return con;
        }
        /// <summary>
        /// 根据Mongo连接和数据库名字获取数据库
        /// </summary>
        /// <param name="mongo">Mongo连接</param>
        /// <param name="name">数据库名字</param>
        /// <returns></returns>
        public IMongoDatabase GetDataBase(IMongo mongo, string name)
        {
            return mongo.GetDatabase(name);
        }
        /// <summary>
        /// 根据名字获取数据库
        /// </summary>
        /// <param name="name">数据库名字</param>
        /// <returns></returns>
        public IMongoDatabase GetDataBase(string name)
        {
            var con = GetMongoConnection();

            return GetDataBase(con, name);
        }
        /// <summary>
        /// 获取集合
        /// </summary>
        /// <typeparam name="T">集合的实体类型定义</typeparam>
        /// <param name="database">数据库</param>
        /// <returns></returns>
        public IMongoCollection<T> GetCollection<T>(IMongoDatabase database) where T : class
        {
            return database.GetCollection<T>();
        }

        /// <summary>
        /// 执行特定数据库中的操作
        /// </summary>
        /// <param name="name">数据库名字</param>
        /// <param name="process">具体操作</param>
        public void Excute(string name, Action<IMongoDatabase> process)
        {
            using (var con = GetMongoConnection())
            {
                con.Connect();
                Excute(name, con, process);
            }
        }

        public void Excute(string name, IMongo connection, Action<IMongoDatabase> process)
        {
            var db = GetDataBase(connection, name);
            process(db);
        }

        /// <summary>
        /// 执行特定数据中的特定集合的操作
        /// </summary>
        /// <typeparam name="T">数据库集合的类型定义</typeparam>
        /// <param name="name">数据库名字</param>
        /// <param name="process">具体的操作</param>
        public void Excute<T>(string name, Action<IMongoCollection<T>> process) where T : class
        {
            Excute(name, database =>
            {
                var collection = database.GetCollection<T>();
                process(collection);
            });
        }

        /// <summary>
        /// 添加实体数据T到数据库
        /// </summary>
        /// <typeparam name="T">实体数据类型</typeparam>
        /// <param name="name">数据库名</param>
        /// <param name="t">实体数据实例</param>
        public void Add<T>(string name, T t) where T:class
        {
            Excute<T>(name, process =>
                {
                    process.Insert(t);
                });
        }

        /// <summary>
        /// 更新实体数据T到数据库
        /// </summary>
        /// <typeparam name="T">实体数据类型</typeparam>
        /// <param name="name">数据库名</param>
        /// <param name="t">实体数据实例</param>
        public void Update<T>(string name, T t) where T : class
        {
            Excute<T>(name, process =>
                {
                    //process.Update(t);
                    process.Save(t);
                });
        }
        /// <summary>
        /// 删除实体数据
        /// </summary>
        /// <typeparam name="T">实体数据类型</typeparam>
        /// <param name="name">数据库名</param>
        /// <param name="t">实体数据实例</param>
        public void Delete<T>(string name, T t) where T : class
        {
            Excute<T>(name, process =>
                {
                    process.Remove(t);
                });
        }
    }
}
