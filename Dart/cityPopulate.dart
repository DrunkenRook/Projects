import 'dart:math';
class createGrid
{
  List<List<int>> grid = [[]];

    createGrid(n)
    {
        grid.removeAt(0);
        grid = fill(n);
    }
  
  List<List<int>> fill(int n)
  {
    Random rng = Random();
    for(int i = 0; i < n; i++) 
      {
          List<int> row = [];
          for(int i = 0; i < n; i++) 
          {
              row.add(rng.nextInt(10)+1);
          }
          grid.add(row);
      }
    return grid;
  }

  bool checkPos(int x,int y)
  {
    if (x < 10 && x > -1 && y < 10 && y > -1)
    {
        return true;
    }
    else
    {
        return false;
    }
  }

  void setPos(int x, int y, int val)
  {
    if (checkPos(x,y) && grid[x][y] != 100)
    {
        grid[x][y] = val;
    }
  }
  
  List<List<int>> cityPopulate(List<List<int>> grid)
  {
    Random rng = Random();
    for (int i = 0; i < 2; i++)
    {
        int x = rng.nextInt(10);
        int y = rng.nextInt(10);

        grid[x][y] = 100;
        print("here ${x} ${y}");

        if (checkPos(x-1, y) && grid[x-1][y] != 100)
        {
            grid[x-1][y] = 50;
            setPos(x-2, y, 25);
            setPos(x-1, y-1, 25);
            setPos(x-1, y+1, 25);
        }
        if (checkPos(x+1, y) && grid[x+1][y] != 100)
        {
            grid[x+1][y] = 50;
            setPos(x+2, y, 25);
            setPos(x+1, y-1, 25);
            setPos(x+1, y+1, 25);
        }
        if (checkPos(x, y-1) && grid[x][y-1] != 100)
        {
            grid[x][y-1] = 50;
            setPos(x, y-2, 25);
            setPos(x-1, y-1, 25);
            setPos(x+1, y-1, 25);
        }
        if (checkPos(x, y+1) && grid[x][y+1] != 100)
        {
            grid[x][y+1] = 50;
            setPos(x, y+2, 25);
            setPos(x-1, y+1, 25);
            setPos(x+1, y+1, 25);
        }
    }
     return grid;
  }




  
}



void main() 
{
  createGrid temp = createGrid(10);
  for (int i = 0; i < temp.grid.length; i++) 
  {
    print(temp.grid[i]);
  }
  print("\n _________________________________________ \n");
  temp.cityPopulate(temp.grid);
  for (int i = 0; i < temp.grid.length; i++)
  {
    print(temp.grid[i]);
  }

}
