$(document).ready(function() {
  var oTable, default_val;
  return oTable = $("#listings").dataTable({
    bJQueryUI: true,
    bPaginate: true,
    sPaginationType: "full_numbers",
    bStateSave: true,
    iDisplayLength: 10},
    $("select#show_act_inact").change(function() {
        var regex, val;
        val = $("select#show_act_inact option:selected").attr("value");
        regex = (val === "" ? "" : "^" + val + "$");
        return oTable.fnFilter(regex, 6, true);
      }));
});

this.screenshotPreview = function(){
  /* CONFIG */

    xOffset = 10;
    yOffset = 30;

    // these 2 variable determine popup's distance from the cursor
    // you might want to adjust to get the right result

  /* END CONFIG */
  $("a.screenshot").hover(function(e){
    this.t = this.title;
    this.title = "";
    var c = (this.t != "") ? "<br/>" + this.t : "";
    $("body").append("<p id='screenshot'><img src='"+ this.rel +"' alt='url preview' />"+ c +"</p>");
    $("#screenshot")
      .css("top",(e.pageY - xOffset) + "px")
      .css("left",(e.pageX + yOffset) + "px")
      .fadeIn("fast");
    },
  function(){
    this.title = this.t;
    $("#screenshot").remove();
    });
  $("a.screenshot").mousemove(function(e){
    $("#screenshot")
      .css("top",(e.pageY - xOffset) + "px")
      .css("left",(e.pageX + yOffset) + "px");
  });
};


// starting the script on page load
$(document).ready(function(){
  screenshotPreview();
});
