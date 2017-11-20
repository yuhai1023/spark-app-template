package common

import java.io.File
import java.util.Properties

import com.typesafe.config.{Config, ConfigFactory, ConfigValue}
import org.apache.hadoop.conf.Configuration
import org.slf4j.{Logger, LoggerFactory}

import scala.util.Try

trait Configurable {

  private val logger: Logger = LoggerFactory.getLogger(this.getClass)

  private lazy val global: Config =
    Try {
      val file = new File("config/application.conf")
      assert(file.exists())
      ConfigFactory.parseFile(file)
    }.getOrElse {
      logger.info("Loading file in config/application.conf failed, use it in jar.")
      ConfigFactory.load()
    }

  private lazy val switch: String = global.getString("config.switch")

  private lazy val specified: Config = Try {
    val file = new File(s"config/application-$switch.conf")
    assert(file.exists())
    ConfigFactory.parseFile(file)
  }.getOrElse {
    logger.info(s"Loading file in config/application-$switch.conf failed, use it in jar.")
    ConfigFactory.load(s"application-$switch")
  }

  implicit class HdfsConfigurationWrapper(val hdfsConf: Configuration) {
    def add(conf: Config): Unit = {
      conf.toMap.foreach { case (k, v) => hdfsConf.set(k, v) }
    }
  }

  implicit class TypeSafeConfigWrapper(conf: Config) {
    def toProperties: Properties = {
      val props = new Properties()
      conf.entrySet().toArray[java.util.Map.Entry[String, ConfigValue]](Array()).foreach { entry =>
        entry.getKey
        props.put(entry.getKey, entry.getValue.unwrapped())
      }
      props
    }

    def toMap: Map[String, String] = {
      conf.entrySet().toArray[java.util.Map.Entry[String, ConfigValue]](Array()).map { entry =>
        entry.getKey -> entry.getValue.unwrapped().toString
      }.toMap
    }
  }

  protected def confGlobal: Config = global

  protected def confBlock(blockName: String): Config =
    if (specified.hasPath(blockName)) {
      specified.getConfig(blockName)
    } else if (global.hasPath(blockName)) {
      global.getConfig(blockName)
    } else {
      throw new RuntimeException(s"both global and specified config didn't has block $blockName")
    }

  protected def confProp(configName: String): Properties = confBlock(configName).toProperties

  protected def confMap(configName: String): Map[String, String] = confBlock(configName).toMap

  protected def confModule(moduleName: String): Config = {
    ConfigFactory.load(s"application-$moduleName")
  }
}
