
object SparkStarter extends SparkApp {

  val rdd = sc.parallelize(
    1 to 10
  )

  println(rdd.sum())

}
