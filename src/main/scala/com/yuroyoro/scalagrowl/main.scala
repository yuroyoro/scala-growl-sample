package com.yuroyoro.scalagrowl

import info.growl.{Growl, GrowlUtils}
import java.io.File
import javax.imageio.ImageIO

object GrowlTest extends Application{

  val appName = "How do you like wednesday Growl"
  val notificationName = "How do you like wednesday Growl"
  val growl:Growl  = GrowlUtils.getGrowlInstance( appName )
  growl.addNotification(notificationName , true)
  growl.register()

  val icon = ImageIO.read(new File("icon.png"))

  val message = List(
      ("腹をわって話そう","藤村Ｄ"),
      ("ギアいじったっけロー入っちゃってもうウィリーさ","大泉洋"),
      ("屁ぐらいこかせなさいよ","大泉洋"),
      ("荒くれ者だけにそっち方面に荒くれられたらえらい目に会いますからね","大泉洋"),
      ("あぁーそうかそうか今年も四国かぁ","大泉洋"),
      ("お前は俺より若いんだから俺より高く翔べ","鈴井貴之"),
      ("四国でクリームパン食ったろお前","藤村Ｄ"),
      ("まっ直ぐ運転しろって借金野郎","藤村Ｄ"),
      ("ひょうおぅ","鈴井貴之"),
      ("多少はペーソスを効かせなさいよ","藤村Ｄ"),
      ("マヌケな顔で寝てなさいよ","大泉洋"),
      ("案ずるな受験生","大泉洋"),
      ("もう帰ろふよ寒いんだよ何処へ行かふと","大泉洋"),
      ("しもまるこちゃん","大泉洋"),
      ("八十八ヶ所回ってきましたハイ地獄へ行ってください","大泉洋"),
      ("弾劾を受けてる時点でこらぁ藤村くん反省でしょ","大泉洋"),
      ("船長これ吐く時は海かい","藤村Ｄ"),
      ("目が覚めたらロザンナの家だった","大泉洋"),
      ("ここをキャンプ地とする","藤村Ｄ")
      )

  message.foreach({ x => growl.sendNotification(notificationName ,  x._2,  x._1, icon)})

}

