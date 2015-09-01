$(function() {

  // initial sort set using sortList option
  $(".sort").tablesorter({
    theme : 'grey',
    // sort on the first column and second column in ascending order
    sortList: [[-1,-1],[1,0]]
  });

});
