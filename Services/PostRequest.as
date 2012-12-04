/*
  Copyright (c) 2010, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.facebook.graph.utils {

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * Formats a file upload request.
	 *
	 */
	public class PostRequest {

		/**
		 * @private
		 *
		 */
		public var boundary:String = '-----';

		/**
		 * @private
		 *
		 */
		protected var postData:ByteArray;


		/**
		 * Instantiates a new PostRequest instance.
		 *
		 */
		public function PostRequest() {
			createPostData();
		}

		/**
		 * Starts a new request.
		 *
		 */
		public function createPostData():void {
			postData = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;
		}

		/**
		 * Writes a new value to the current POST request.
		 *
		 * @param name Name of the new value.
		 * @param value String value to write to the POST data.
		 *
		 */
		public function writePostData(name:String, value:String):void {
			var bytes:String;

			writeBoundary();
			writeLineBreak();

			bytes = 'Content-Disposition: form-data; name="' + name + '"';

			var l:uint = bytes.length;
			for (var i:Number=0; i<l; i++)  {
				postData.writeByte( bytes.charCodeAt(i) );
			}

			writeLineBreak();
			writeLineBreak();

			postData.writeUTFBytes(value);

			writeLineBreak();
		}

		/**
		 * Writes a ByteArray to the POST request.
		 *
		 * @param filename Name of the file data to upload.
		 * @param fileData Raw byte array of file data to upload.
		 * @contentType Content type of data being uploaded (ex. ContentType: image/png).
		 *
		 */
		public function writeFileData(
			filename:String,
			fileData:ByteArray,
			contentType:String):void {

			var bytes:String;
			var l:int;
			var i:uint;

			writeBoundary();
			writeLineBreak();
			
			bytes = 'Content-Disposition: form-data; name="'+filename+'"; filename="'+filename+'";';
			l = bytes.length;

			for (i=0; i<l; i++)  {
				postData.writeByte(bytes.charCodeAt(i));
			}

			postData.writeUTFBytes(filename);

			writeQuotationMark();
			writeLineBreak();

			bytes = contentType || "application/octet-stream";
			l = bytes.length;
			for (i=0; i<l; i++) {
				postData.writeByte(bytes.charCodeAt(i));
			}

			writeLineBreak();
			writeLineBreak();

			fileData.position = 0;
			postData.writeBytes(fileData, 0, fileData.length);

			writeLineBreak();
		}

		/**
		 * Returns the POST bytes to upload.
		 *
		 */
		public function getPostData():ByteArray {
			postData.position = 0;
			return postData;
		}

		/**
		 * Closes this request. This method must be called last.
		 *
		 */
		public function close():void {
			writeBoundary();
			writeDoubleDash();
		}

		/**
		 * @private
		 *
		 */
		protected function writeLineBreak():void {
			postData.writeShort(0x0d0a);
		}

		/**
		 * @private
		 *
		 */
		protected function writeQuotationMark():void  {
			postData.writeByte(0x22);
		}

		/**
		 * @private
		 *
		 */
		protected function writeDoubleDash():void {
			postData.writeShort(0x2d2d);
		}


		/**
		 * @private
		 *
		 */
		protected function writeBoundary():void  {
			writeDoubleDash();

			var l:uint = boundary.length;
			for (var i:uint=0; i<l; i++)  {
				postData.writeByte(boundary.charCodeAt(i));
			}
		}

	}
}