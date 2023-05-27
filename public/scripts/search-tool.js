function searchData() {
    var input = document.getElementById('searchInput').value.toLowerCase().replace(/\s/g, '');
    var table = document.getElementById('data-table');
    var rows = table.getElementsByTagName('li');

    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      var cells = row.getElementsByTagName('div');
      var match = false;

      for (var j = 0; j < cells.length; j++) {
        var cell = cells[j];
        var cellText = cell.textContent.toLowerCase().replace(/\s/g, '');

        if (cellText.indexOf(input) > -1) {
          match = true;
          break;
        }
      }

      row.style.display = match ? 'flex' : 'none';
    }
  }