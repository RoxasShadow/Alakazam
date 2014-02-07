#! /usr/bin/env ruby
#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++
require 'alakazam'

class Shiftry
  include Alakazam
  extend  Alakazam # required only to observe class methods
  attr_accessor :lal

  def lol
    fire!
    notify 'fired'
  end

  def lel
    notify 'fired'
  end

  def self.lul
    fire!
    notify 'fired'
  end
end

class Logger
  def initialize
    @i = 0
  end

  def update(*things)
    @i += 1
  end

  def counter
    @i
  end

  def self.on_fire(*things)
    @@i  = 0 if not defined? @@i
    @@i += 1
  end

  def self.counter
    @@i
  end
end

describe Alakazam do
  before do
    @counter = 0
  end

  let(:logger) do
    ->(*things) {
      @counter += 1
    }
  end

  let(:shiftry) { Shiftry.new }

  it 'invokes the given block when notified by observed class' do
    shiftry.is_observed_by { |*things|
      @counter += 1
    }

    shiftry.lol
    shiftry.lol

    shiftry.lel
    shiftry.lel

    @counter.should be 2
  end

  it 'invokes the given block without explicit notify when notified by observed class' do
    shiftry.is_observed_by(nil, on_change: false) { |*things|
      @counter += 1
    }

    shiftry.lol
    shiftry.lol

    shiftry.lel
    shiftry.lel

    @counter.should be 4
  end

  it 'invokes a Proc when notified by observed class' do
    shiftry.is_observed_by logger

    shiftry.lol
    shiftry.lol

    shiftry.lel
    shiftry.lel

    @counter.should be 2
  end

  it 'invokes a Proc without explicit notify when notified by observed class' do
    shiftry.is_observed_by logger, on_change: false

    shiftry.lol
    shiftry.lol

    shiftry.lel
    shiftry.lel

    @counter.should be 4
  end

  it 'invokes a Proc when notified by a class method of the observed class' do
    Shiftry.is_observed_by logger

    Shiftry.lul
    Shiftry.lul

    @counter.should be 2
  end

  it 'invokes the logger\'s custom and default method when notified by observed class' do
    logger = Logger.new

    shiftry.is_observed_by Logger.new, methods: [ :on_fire, :non_existing_method ]
    shiftry.is_observed_by logger

    shiftry.lol

    logger.counter.should be 1
    Logger.counter.should be 1
  end

  it 'invokes the logger\'s default method when a variable changes in the observed class' do
    Logger.new.tap { |logger|
      shiftry.is_observed_by logger, attributes: { var: :lal, notify: 'fired' }

      shiftry.lal = 3
      shiftry.lal.should be 3

      shiftry.lal = 4
      shiftry.lal.should be 4
    }.counter.should be 2
  end

  it 'handles correctly the observers of the observed class' do
    shiftry.is_observed_by Logger.new
    shiftry.is_observed_by logger

    shiftry.has_observer?(logger).should be true
    shiftry.count_observers.should       be 2

    shiftry.delete_observer logger
    shiftry.count_observers.should       be 1

    expect { shiftry.__observers__ }.to raise_error
  end
end