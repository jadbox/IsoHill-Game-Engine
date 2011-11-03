package isohill 
{
	/**
	 * Fixed two directional int vector 
	 * + using single vector math for performance
	 * @author Jonathan Dunlap
	 */
	public class GridInt 
	{
		private var data:Vector.<int>;
		private var width:int=0;
		private var height:int=0;
		public function GridInt(width:int, height:int) 
		{
			this.width = width;
			this.height = height;
			if (width == 0 && height == 0) throw new Error("Invalid starting size of 0,0");
			width = Math.max(width, 1); // ensure that it's not zero as an example of 0 width times 1 height would be zero
			height = Math.max(height, 1); // same here
			data = new Vector.<int>(width * height, true); // make a prefined fixed sized array for performance
		}
		public function getCell(x:int, y:int):int {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index];
		}
		public function setCell(x:int, y:int, value:int):int {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index] = value;
		}
	}

}