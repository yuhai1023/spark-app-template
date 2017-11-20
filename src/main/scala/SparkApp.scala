import common.Configurable
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession

trait SparkApp extends App with Configurable {

  val conf = new SparkConf().setAppName(this.getClass.getName.stripSuffix("$"))
  val switch = confGlobal.getString("config.switch")
  if (switch.equals("dev")) {
    conf.setMaster("local")
  }

  implicit val spark = SparkSession.builder().config(conf).getOrCreate()

  implicit val sc = spark.sparkContext

  val logLevel = confGlobal.getString("logger.level")
  sc.setLogLevel(logLevel)

  implicit val sqlContext = spark.sqlContext

}
