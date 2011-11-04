#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
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
