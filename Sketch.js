;
let cols;
let squareSize;
let cells;
let surviveRules;
let birthRules;
let run;

function setup() {
  squareSize = 4;
  rows = min(150, floor(windowHeight / squareSize));
  cols = min(150, floor(windowWidth / squareSize));
  createCanvas(cols * squareSize, rows * squareSize);

  ellipseMode(CORNER);
  rectMode(CORNER);
  noStroke();
  fill(255);

  birthRules = [3];
  surviveRules = [2, 3];

  init(true);
  run = true;
}

function init(randomize) {
  background(0);
  cells = newBooleanArray(rows, cols);
  if (randomize) {
    for (let i = 0; i < rows; i++) {
      for (let j = 0; j < cols; j++) {
        cells[i][j] = random() > 0.5;
      }
    }
  }
}

function neighboursNumber(row, col) {
  let count = 0;
  for (let y = -1; y <= 1; y++) {
    for (let x = -1; x <= 1; x++) {
      let r = (row + y + rows) % rows;
      let c = (col + x + cols) % cols;
      if ((y != 0 || x != 0) && cells[r][c]) {
        count++;
      }
    }
  }

  return count;
}

function newBooleanArray(rows, cols) {
  let arr = [];
  for (let i = 0; i < rows; i++) {
    let row = [];
    for (let j = 0; j < cols; j++) {
      row.push(false);
    }
    arr.push(row);
  }
  return arr;
}

function keyPressed() {
  if (keyCode == 67) // C
    init(false);
  else if (keyCode == 82) // R
    init(true);
  else if (keyCode == 80) // P
    run = !run;
}

function mouseClicked() {
  let x = floor(mouseX / squareSize);
  let y = floor(mouseY / squareSize);
  cells[y][x] = !cells[y][x];
  if (!run) {
    if (cells[y][x]) {
      rect(x * squareSize, y * squareSize, squareSize, squareSize);
    } else {
      stroke(0);
      rect(x * squareSize, y * squareSize, squareSize, squareSize);
      stroke(255);
    }
  }
}

function draw() {
  if (!run) return;
  background(0);

  let next = newBooleanArray(rows, cols);

  for (let y = 0; y < rows; y++) {
    for (let x = 0; x < cols; x++) {
      let neighbours = neighboursNumber(y, x);
      next[y][x] = (cells[y][x] && surviveRules.includes(neighbours)) || (!cells[y][x] && birthRules.includes(neighbours))
      if (next[y][x])
        rect(x * squareSize, y * squareSize, squareSize, squareSize);
    }
  }

  cells = next;
}
