require_relative "static_array"
require "byebug"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @store = StaticArray.new(length)
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    @store[index] = value
  end

  # O(1)
  def pop
    check_index(@length - 1)
    @length -= 1
    value = @store[@length]
    @store[@length] = nil
    value
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    @length += 1
    resize! if @length > @capacity

    @store[@length - 1] = val
  end

  # O(n): has to shift over all the elements.
  def shift
    check_index(@length - 1)
    value = @store[0]
    @length -= 1

    (0...@length).each { |i| @store[i] = @store[i + 1] }

    value
  end

  #[2,3,4] => 3 => 4


  # O(n): has to shift over all the elements.
  def unshift(val)
    @length += 1
    resize! if @length > @capacity

    (@length - 1).downto(1).each { |i| @store[i] = @store[i - 1] }
    @store[0] = val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise("index out of bounds") if index >= @length || index < 0
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_store = StaticArray.new(2 * @capacity)

    (0...@capacity).each { |i| new_store[i] = @store[i] }

    @store = new_store
    @capacity *= 2
  end
end
