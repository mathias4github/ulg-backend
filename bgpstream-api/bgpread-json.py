from wsgiref.simple_server import make_server
from pyramid.config import Configurator
from pyramid.response import Response
from pyramid.view import view_config
import pyramid.httpexceptions as exc
import re

from pyramid.request import Request

from _pybgpstream import BGPStream, BGPRecord, BGPElem
from datetime import time, timedelta
import json

#@view_config(renderer='json')
def data(request):
    import pdb; pdb.set_trace()
       
    #for prameter in request.GET.keys():

    collector, start, end = 0

    if request.GET.has_key("route_collector"):
       collector=request.GET["route_collector"]
    if request.GET.has_key('timespan_start'):
       start=request.GET["timespan_start"]     
    if request.GET.has_key('timespan_end'):
       end=request.GET["timespan_end"]

    # create a new bgpstream instance
    stream = BGPStream()

    # select the data source
    # on the CLI it works this way $ bgpreader -d sqlite -o db-file,ULG.sqlite -w 1477000000,1777360000
    stream.set_data_interface("sqlite")
    print("collector from URL is: " + collector)
    # FIXME Use the collector name
    stream.set_data_interface_option('db-file', collector +'.sqlite')

    # create a reusable bgprecord instance
    rec = BGPRecord()

    #if start >= 0 and end >= 0
     # do something
    #else
     # do the default timerange
   
    
    return response

if __name__ == '__main__':
    config = Configurator()
    config.add_route('bgpread', '/peers/')
    config.add_view(data, route_name='bgpread', renderer='json')
    app = config.make_wsgi_app()
    server = make_server('0.0.0.0', 8080, app)
    server.serve_forever()
   

