require 'tesseract'
require 'mini_magick'

TMP_IMAGE_BASE = "./tmp/output"

SCALE = 4

def main(image_path)
	e = Tesseract::Engine.new do |e|
		e.language  = :eng
		e.blacklist = '|'
	end

	`pdftoppm -png #{image_path} #{TMP_IMAGE_BASE}`

	working_img = MiniMagick::Image.open("#{TMP_IMAGE_BASE}-1.png")
	rect = Rectangle.new(width: 170, height: 30, x: 150, y: 300)
	#rect = Rectangle.new(width: 150, height: 150, x: 0, y: 0)

	working_img.crop(rect.to_s)

	zoom = (SCALE ** 2) * 100
	working_img.resize("#{zoom}%")

	working_img.write("#{TMP_IMAGE_BASE}-final.png")

	puts e.text_for(working_img).strip
end

class Rectangle
	attr_accessor :x, :y, :width, :height

	def initialize(ops)
		self.x = ops[:x]
		self.y = ops[:y]
		self.width = ops[:width]
		self.height = ops[:height]
	end

	def scale(scaler)
		self.x = x * scaler
		self.y = y * scaler
		self.width = width * scaler
		self.height = height * scaler
	end

	def to_s
		"#{width}x#{height}+#{x}+#{y}"
	end
end

image_path = ARGV[0]
main(image_path)