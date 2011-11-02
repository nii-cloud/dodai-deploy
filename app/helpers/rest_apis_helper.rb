module RestApisHelper

  def rest_api_table(id, url, method = "get", parameters = [])
    html_str = "" 
    parameters.each{|param| html_str += "<tr><th>#{param}</th><td><input></input></td></tr>\n"}

    result = <<EOT 
<table width="100%" class="rest_api_table">
  <tr>
    <th rowspan=3>Request</th>
    <th>url</th>
    <td id="#{id}_url_td" width="70%">#{url}</td>
    <td rowspan=3><input type="button" value="Execute" id="#{id}_btn"/><img src="/images/processing.gif" class="processing_img"/></td>
  </tr>
  <tr>
    <th>method</th>
    <td id="#{id}_method_td">#{method}</td>
  </tr>
  <tr>
    <th>parameters</th>
    <td><table id="#{id}_parameters_table">
      #{html_str}
    </table></td>
  </tr>
  <tr>
    <th>Response</th>
    <td colspan=3><textarea id="#{id}_result_textarea" rows=1 readonly=true></textarea></td>
  </tr>
</table>
EOT

  end
end
