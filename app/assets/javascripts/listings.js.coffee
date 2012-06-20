$(document).ready ->
  oTable = $("#listings").dataTable
    bJQueryUI: true,
    bPaginate: true,
    sPaginationType: "full_numbers",
    bStateSave: true
    iDisplayLength: 10
    $("select#show_act_inact").change ->
        val = $("select#show_act_inact option:selected").attr("value")
        regex = (if val is "" then "" else "^" + val + "$")
        oTable.fnFilter regex, 5, true



