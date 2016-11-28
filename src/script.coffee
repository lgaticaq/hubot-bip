# Description
#   Obtiene el saldo de una tarjeta bip
#
# Dependencies:
#   "bip": "^2.0.1"
#
# Commands:
#   hubot bip <number> -> Obtiene saldo de tarjeta bip
#
# Author:
#   lgaticaq

bip = require("bip")

module.exports = (robot) ->
  robot.respond /bip (\d+)/i, (res) ->
    addZero = (i) ->
      i = "0#{i}" if i < 10
      return i

    bip(res.match[1])
      .then (data) ->
        msg = "Número: #{data.number}\n"
        msg += "Saldo: $#{data.balance}\n"
        if data.date
          hour = addZero(data.date.getUTCHours() - 3)
          date = data.date.toISOString().replace(
            /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):\d{2}\.\d+Z/,
            "$3/$2/$1 #{hour}:$5")
          msg += "Fecha: #{date}\n"
        msg += "Mensaje: #{data.message}"
        robot.send({room: res.message.user.id}, msg)
      .catch (err) ->
        res.reply "ocurrio un error al consultar la tarjeta bip." +
        "\nError: #{err.message}"
        robot.emit("error", err)
