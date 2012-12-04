# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
        $('#patients').dataTable
            "sDom": "<'row-fluid'<'form-actions'f>rtp>"
            "bInfo": false
            "bLengthChange": false
            "sPaginationType": "bootstrap"
            "iDisplayLength": 1
            "aoColumnDefs": [
                        { "bSearchable": false,	"aTargets": [ 3 ] }
                        { "bSortable"  : false,	"aTargets": [ 6 ] }
             ]

  	
 
