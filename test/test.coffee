Helper = require("hubot-test-helper")
expect = require("chai").expect
proxyquire = require("proxyquire")

bipStub = (number) ->
  return new Promise (resolve, reject) ->
    if number is "11111111"
      resolve
        number: "11111111"
        balance: 1180
        date: new Date("2016-01-02T20:59:00-03:00")
        message: "Tarjeta Valida"
        valid: true
    else if number is "33333333"
      resolve
        number: "33333333"
        balance: 1180
        date: new Date("2016-01-02T09:59:00-03:00")
        message: "Tarjeta Valida"
        valid: true
    else if number is "44444444"
      resolve
        number: "44444444"
        balance: 1180
        message: "Tarjeta Valida"
        valid: true
    else
      reject(new Error("Not found"))

proxyquire("./../src/script.coffee", {"bip": bipStub})
helper = new Helper("./../src/index.coffee")

describe "bip", ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  context "number valid", ->
    beforeEach (done) ->
      @room.user.say("user", "hubot bip 11111111")
      setTimeout(done, 100)

    it "should return a balance data", ->
      expect(@room.messages).to.eql([
        ["user", "hubot bip 11111111"],
        [
          "hubot",
          "Número: 11111111\nSaldo: $1180\nFecha: 02/01/2016 20:59" +
          "\nMensaje: Tarjeta Valida"
        ]
      ])

  context "number invalid", ->
    beforeEach (done) ->
      @room.user.say("user", "hubot bip 22222222")
      setTimeout(done, 100)

    it "should return an error", ->
      expect(@room.messages).to.eql([
        ["user", "hubot bip 22222222"],
        [
          "hubot",
          "@user ocurrio un error al consultar la tarjeta bip." +
          "\nError: Not found"
        ]
    ])

  context "addZero", ->
    beforeEach (done) ->
      @room.user.say("user", "hubot bip 33333333")
      setTimeout(done, 100)

    it "should return a balance data", ->
      expect(@room.messages).to.eql([
        ["user", "hubot bip 33333333"],
        [
          "hubot",
          "Número: 33333333\nSaldo: $1180\nFecha: 02/01/2016 09:59" +
          "\nMensaje: Tarjeta Valida"
        ]
    ])

  context "without date", ->
    beforeEach (done) ->
      @room.user.say("user", "hubot bip 44444444")
      setTimeout(done, 100)

    it "should return a balance data", ->
      expect(@room.messages).to.eql([
        ["user", "hubot bip 44444444"],
        [
          "hubot",
          "Número: 44444444\nSaldo: $1180\nMensaje: Tarjeta Valida"
        ]
    ])
