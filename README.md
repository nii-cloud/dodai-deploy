Welcome to the **dodai-deploy project**

## News 
* [2012/11/20] Upgrade hadoop 0.20.2 to **hadoop 0.22.0**.
 * hadoop 0.20.2 couldn't be downloaded from hadoop official site any more.
* [2012/11/02] Eucalyptus 3.1 can be installed on **ubuntu 12.04**.
 * [Install eucalyptus 3.1 on ubuntu 12.04](/nii-cloud/dodai-deploy/wiki/Install-eucalyptus-3.1-on-ubuntu-12.04)
* [2012/10/26] Openstack folsom can be installed on **ubuntu 12.04**.
* [2012/05/16] hadoop can be installed on **ubuntu 12.04**.
* [2012/04/13] Add supports for Openstack Essex. Please refer the following blog for how-to.
 * [Install nova essex(all-in-one) with dodai-deploy on ubuntu 12.04](http://www.guanxiaohua2k6.com/2012/04/install-openstack-nova-essex-with-dodai.html)
 * [Install nova essex(multiple machines) with dodai-deploy on ubuntu 12.04](http://www.guanxiaohua2k6.com/2012/04/install-openstack-nova-essexmultiple.html)

## Introduction
The dodai-deploy is a software management tool. It supports the following softwares.

* OpenStack Folsom(Compute, Glance, Swift, Keystone)
* OpenStack Essex(Nova, Glance, Swift, Keystone)
* OpenStack Diablo(Nova, Glance, Swift) 
* hadoop 0.22.0
* sun grid engine 6.2u5

## Features
* Manage installation, uninstallation and testing of a software.
* Support deployment on multiple machines. 
* Support target machines in different network segments.
* Provide web UI to facilitate user operations.
* Provide REST API to make it possible to integrate it with other tools.
* Support parallel installation of software components.

## OSes supported
The following OSes are supported.
<table>
   <tr>
       <td></td>
       <td>ubuntu 10.10</td>
       <td>ubuntu 11.04</td>
       <td>ubuntu 11.10</td>
       <td>ubuntu 12.04</td>
   </tr>
   <tr>
       <td>OpenStack Folsom(Compute, Glance, Keystone, Swift)<br/>Compute includes Nova, Horizon, Quantum, Cinder</td>
       <td></td>
       <td></td>
       <td></td>
       <td>:)</td>
   </tr>
   <tr>
       <td>OpenStack Essex(Nova, Glance, Swift, Keystone)</td>
       <td></td>
       <td></td>
       <td></td>
       <td>:)</td>
   </tr>
   <tr>
       <td>OpenStack Diablo(Nova, Glance, Swift)</td>
       <td>:)</td>
       <td>:)</td>
       <td>:)</td>
       <td></td>
   </tr>
   <tr>
       <td>hadoop 0.22.0</td>
       <td>:)</td>
       <td>:)</td>
       <td>:)</td>
       <td>:)</td>
   </tr>
   <tr>
       <td>sun grid engine 6.2u5</td>
       <td>:)</td>
       <td>:)</td>
       <td>:)</td>
       <td></td>
   </tr>
</table>

## User guide
Please refer to [User guide](/nii-cloud/dodai-deploy/wiki/User-guide). 

## Developer guide
Please refer to [Developer guide](/nii-cloud/dodai-deploy/wiki/Developer-guide).

## FAQ
Please refer to [FAQ](/nii-cloud/dodai-deploy/wiki/FAQ).