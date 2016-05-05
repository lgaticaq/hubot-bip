path = require("path")
Helper = require("hubot-test-helper")
expect = require("chai").expect
nock = require("nock")

helper = new Helper("./../src/index.coffee")

describe "bip", ->
  room = null

  beforeEach ->
    room = helper.createRoom()
    nock.disableNetConnect()

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context "number valid", ->
    number = "11111111"

    beforeEach (done) ->
      nock("http://www.metrosantiago.cl")
        .get("/contents/guia-viajero/includes/consultarTarjeta/#{number}")
        .reply(200, [
          {
            "estado": 0,
            "mensaje": "Tarjeta Valida"
          },
          {
            "salida": true,
            "tarjeta": "11111111",
            "saldo": "1180",
            "fecha": "02\/01\/2016 20:59"
          }
        ])
      room.user.say("leon", "hubot bip #{number}")
      setTimeout(done, 100)

    it "should return a balance data (valid)", ->
      expect(room.messages).to.eql([
        ["leon", "hubot bip #{number}"],
        ["hubot", "Número: 11111111\nSaldo: $1180\nFecha: 02/01/2016 20:59\nMensaje: Tarjeta Valida"]
      ])

  context "number invalid", ->
    number = "11111111"

    beforeEach (done) ->
      nock("http://www.metrosantiago.cl")
        .get("/contents/guia-viajero/includes/consultarTarjeta/#{number}")
        .reply(200, [
          {
            "estado": 1,
            "mensaje": "Esta tarjeta no se puede cargar"
          },
          {
            "salida": false,
            "tarjeta": "11111111"
          }
        ])
      room.user.say("leon", "hubot bip #{number}")
      setTimeout(done, 100)

    it "should return a balance data (invalid)", ->
      expect(room.messages).to.eql([
        ["leon", "hubot bip #{number}"],
        ["hubot", "@leon ocurrio un error al consultar la tarjeta bip"]
    ])
