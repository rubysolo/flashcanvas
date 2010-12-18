/*
 * FlashCanvas
 *
 * Copyright (c) 2009      Tim Cameron Ryan
 * Copyright (c) 2009-2010 FlashCanvas Project
 * Licensed under the MIT License.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * @author Tim Cameron Ryan
 * @author Shinya Muramatsu
 */

package com.googlecode.flashcanvas
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.utils.ByteArray;
    import com.adobe.images.JPGEncoder;
    import com.adobe.images.PNGEncoder;

    public class Canvas extends Bitmap
    {
        // Directionality of the canvas
        public var dir:String = "ltr";

        private var _context:*;

        public function Canvas(width:int = 300, height:int = 150)
        {
            super(null, PixelSnapping.ALWAYS);
            resize(width, height);
        }

        override public function set width(value:Number):void
        {
            resize(value, height);
        }

        override public function set height(value:Number):void
        {
            resize(width, value);
        }

        public function getContext(contextId:String):*
        {
            if (contextId == "2d")
            {
                if (!_context)
                {
                    _context = new CanvasRenderingContext2D(this);
                    _context.resize(width, height);
                }
                return _context;
            }
            else
            {
                return null;
            }
        }

        public function toDataURL(type:String = "image/png", ...args:Array):String
        {
            if (width == 0 || height == 0)
            {
                return "data:,";
            }

            var byteArray:ByteArray;

            if (/^image\/jpeg$/i.test(type))
            {
                var quality:* = args[0];
                if (typeof quality != "number" || isNaN(quality) ||
                    quality < 0 || quality > 1)
                    quality = 0.5;

                var jpgEncoder:JPGEncoder = new JPGEncoder(quality * 100);

                type      = "image/jpeg";
                byteArray = jpgEncoder.encode(bitmapData);
            }
            else
            {
                type      = "image/png";
                byteArray = PNGEncoder.encode(bitmapData);
            }

            return "data:" + type + ";base64," + Base64.encode(byteArray);
        }

        public function resize(width:int, height:int):void
        {
            // purge existing
            if (bitmapData)
                bitmapData.dispose();

            // create new bitmapdata
            bitmapData = new BitmapData(width, height, true, 0x00000000);
        }
    }
}
