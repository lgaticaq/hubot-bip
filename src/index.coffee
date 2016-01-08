# Description
#   Obtiene el saldo de una tarjeta bip
#
# Dependencies:
#   "bip": "^1.1.0"
#
# Commands:
#   hubot bip <number> -> Número: <numero>, Saldo: <saldo>, Fecha: <fecha>, Mensaje: <mensaje>
#
# Author:
#   lgaticaq

bip = require("bip")
moment = require("moment")

module.exports = (robot) ->
  robot.respond /bip (\d+)/i, (res) ->
    bip(res.match[1])
      .then (data) ->
        msg = "Número: #{data.number}\n"
        msg += "Saldo: $#{data.balance}\n"
        msg += "Fecha: #{moment(data.date).format("DD/MM/YYYY HH:mm")}\n" if data.date
        msg += "Mensaje: #{data.message}"
        robot.send {room: res.message.user.name}, msg
      .catch (err) ->
        res.reply "ocurrio un error al consultar la tarjeta bip"
        robot.emit "error", err, res
