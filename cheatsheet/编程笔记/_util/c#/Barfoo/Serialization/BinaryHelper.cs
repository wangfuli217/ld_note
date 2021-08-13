using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Barfoo.Library.Serialization
{
    public static class BinaryHelper<T>
    {
        public static void WriteObject(T obj, string path)
        {
            var serializer = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            var mstream = new FileStream(path, FileMode.OpenOrCreate);
            serializer.Serialize(mstream, obj);
            mstream.Close();
        }

        public static T ReadObject(string path)
        {
            var mstream = new FileStream(path, FileMode.Open);
            var serializer = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            var obj = serializer.Deserialize(mstream);
            mstream.Close();
            return (T)obj;
        }
    }
}
