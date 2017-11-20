package common

import org.slf4j.{Logger, LoggerFactory}

trait ClassLogger {

  val logger: Logger = LoggerFactory.getLogger(this.getClass)

}
