programas_data = []
function add_programa(slug, nombre, imagen_url, descripcion) {
	programas_data.push({slug:slug, nombre:nombre, imagen_url:imagen_url, descripcion:descripcion});
}

function add_clip(slug, titulo, imagen_url, archivo_url, audio_url, fecha, duracion) {
	programas_data.push({slug:slug, titulo:titulo, descripcion:descripcion, fecha:fecha, archivo_url:archivo_url, audio_url:audio_url, imagen_url:imagen_url, duracion:duracion });
}


var iniciar = function(tipo) {
		Ext.setup({
		//tabletStartupScreen: 'tablet_startup.png',
		//phoneStartupScreen: 'phone_startup.png',
		//icon: 'icon.png',
		//glossOnIcon: false,

		onReady: function() {
			
			Ext.regModel('Programa', {
			    fields: [
					{name: 'slug', type: 'string'},
			        {name: 'nombre', type: 'string'},
			        {name: 'imagen', type: 'string'},
			    ]
			});
			
			Ext.regModel('Clip', {
			    fields: [
					{name: 'slug', type: 'string'},
			        {name: 'titulo', type: 'string'},
			        {name: 'descripcion', type: 'string'},
    			    {name: 'fecha', type: 'string'},
					{name: 'fecha_semana', type: 'string'},
					{name: 'archivo_url', type: 'string'},
					{name: 'audio_url', type: 'string'},
					{name: 'imagen_url', type: 'string'},
					{name: 'duracion', type: 'string'},
					{name: 'tipo__nombre', type: 'string'},
					{name: 'thumbnail_pequeno', type: 'string'},
					{name: 'thumbnail_mediano', type: 'string'},
					{name: 'idioma_original', type: 'string'},
					{name: 'programa__nombre', type: 'string'},
					{name: 'programa__descripcion', type: 'string'},
					{name: 'programa__imagen', type: 'string'}
                    //{name: 'archivo_url', type: 'string'}
			    ]
			});

			var store = new Ext.data.Store({
				model: "Programa",
				data: programas_data
			});
			
			
			var clips_url = '';
			if (tipo == 'programas') {
				clips_url = 'http://multimedia.tlsur.net/api/clip?tipo=programa&formato=ext';
			} else if (tipo == 'documentales') {
				clips_url = 'http://multimedia.tlsur.net/api/clip?tipo=documental&formato=ext';
			} else if (tipo == 'reportajes') {
				clips_url = 'http://multimedia.tlsur.net/api/clip?tipo=reportaje&formato=ext'
			}
			
			clips_store = new Ext.data.Store({
				autoLoad: true,
				pageSize: 10,
				model: "Clip",
				proxy: {
					type: 'ajax',
					startParam: 'offset',
					limitParam: 'limit',
				    url: clips_url,
					reader: {
						type: 'json',
						root: 'clips',
						totalProperty: 'totalCount'
					}
				}
			});
			
			clips_store.on('load', function(store, records, success) {
                    var list = Ext.getCmp('videos_list');
                           list.select(0, false, false);
			});

		    var panel_programas = {
				layout: {
					type: 'hbox'
				},
				dock: 'top',
				flex: 1,
				scroll: 'horizontal',
				height: 90,
				defaults: {
					width: 200,
					height: 80,
					xtype: "button",
					cls: "programa_boton",
					handler: function (btn) {
						if (tipo == 'programas') {
														
							var list = Ext.getCmp('videos_list');
							list.itemTpl = '<div style="line-height:20px;font-size:13px;"><img style="float:left;display:block;vertical-align:middle;margin:0 5px;" height="30" width="52" src="{thumbnail_pequeno}" /><span style="display:block;float:left;width:100px;">{fecha_semana}</span></div>';
							//list.initComponent();
							
							clips_store.proxy.url = 'http://multimedia.telesurtv.net/api/clip?tipo=programa&formato=ext&programa='+btn.id;
							clips_store.load();
							
							list.refresh();
							
						} else {
							clips_store.proxy.url = 'http://multimedia.telesurtv.net/api/clip?formato=ext&tipo='+btn.id;
                            clips_store.load();
						}
					}
				},
				items: []
			};

			for (var i in programas_data) {
				var src = (browser) ? programas_data[i].imagen_url : programas_data[i].slug+".png"; // cache iOS
				panel_programas.items[i] = {id: programas_data[i].slug, ui: 'round', html: "<img style='width:100%;height:100%;' src='"+src+"' />", style:""};
			}
			
			
			var imgsrc = (tipo == 'programas') ? 'http://media.tlsur.net/{programa__imagen}' : (tipo == 'documentales') ? 'documental.png' : 'reportaje.png';
			var titulo = (tipo == 'programas') ? '{programa__nombre}' : '{titulo}';
			var desc   = (tipo == 'programas') ? '{programa__descripcion}' : '{descripcion}';
			var video_detail = new Ext.Panel ({
				layout: {
					type: 'fit',
					align: 'stretch'
				},
				id: 'videodetail',
				style: 'padding-left:30px;',
                                              
                                              
//				tpl: '<div>\
//					<h1 style="line-height:70px;font-size:20px;font-weight:bold;"><img style="vertical-align:middle;" src="'+imgsrc+'" width="120" /> '+titulo+'</h1>\
//						<h3>{fecha_semana} | {duracion}</h3>\
//						<div style="margin-top:1em;height:254px;width:452px;background:#333333;">\
//						    <video id="video" style="margin:0;padding:0;" height="254" width="452" src="{arhcivo_url}" poster="{thumbnail_mediano}" controls />\
//						</div>\
//						<p style="padding-top:1em;font-size:80%;width:400px;">'+desc+'</p>\
//					</div>'
              tpl: '<div>\
              <h1 style="line-height:70px;font-size:20px;font-weight:bold;"><img style="vertical-align:middle;" src="'+imgsrc+'" width="120" /> '+titulo+'</h1>\
              <h3>{fecha_semana} | {duracion}</h3>\
              <div style="margin-top:1em;height:254px;width:452px;background:#333333;position:relative;">\
                  <a href="{archivo_url}">\
                       <img src="Play-icon2.png" width="80" style="display:block;position:absolute;top:85;left:190;" />\
                      <img id="video" style="margin:0;padding:0;" height="254" width="452"  src="{thumbnail_mediano}" />\
                  </a>\
              </div>\
              <p style="padding-top:1em;font-size:80%;width:400px;">'+desc+'</p>\
              </div>'
                                              
                                              
			});
			
			var listTpl = '';
			if (tipo == 'programas') {
				//listTpl = '<div style="line-height:20px;font-size:13px;"><img style="vertical-align:middle;margin:0 5px;" height="30" width="52" src="{thumbnail_pequeno}" />{fecha}</div>';
				listTpl = '<div style="line-height:20px;font-size:12px;"><img style="float:left;display:block;vertical-align:middle;margin:0 5px;" height="30" width="52" src="{thumbnail_pequeno}" /><span style="display:block;float:left;line-height:1em;width:155px;">{titulo}<br /><small><em>{fecha_semana}</em></small></span></div>';
				
			} else {
				listTpl = '<div style="line-height:20px;font-size:12px;"><img style="float:left;display:block;vertical-align:middle;margin:0 5px;" height="30" width="52" src="{thumbnail_pequeno}" /><span style="display:block;float:left;line-height:1em;width:155px;">{titulo}<br /><small><em>{fecha_semana}</em></small></span></div>';
				//listTpl = '<div style="line-height:20px;font-size:13px;"><img style="vertical-align:middle;margin:0 5px;" height="30" width="52" src="{thumbnail_pequeno}" />{titulo}</div>';
			}
			paging = new Ext.plugins.ListPagingPlugin({
				loadMoreText: 'Ver más...',
				//autoPaging: true
			});
			var videos_list = new Ext.List({
				id: 'videos_list',
				flex: 1,
				enablePaging: true,
				store: clips_store,
				itemTpl: listTpl,
				width: 250,
				plugins: [paging]
			});
			
			videos_list.on('selectionchange', function(selecion, items) {
				if (items.length) {
					video_detail.update(items[0].data);
				}
			});
			
			
			
			var videos_panel =  new Ext.Panel({
				layout: 'fit',
				dock: 'left',
				width: 250,
				stretch: true,
				items: [videos_list],
			});
			
			if (tipo != 'programas') {
				panel_programas.style = "display:none;";
			}


			new Ext.Panel({
				layout: {
					type: 'fit'
				},
				fullscreen: true,
				listeners: {
					orientationchange: function() {
					}
				},
				items: [video_detail],
				dockedItems: [
				    panel_programas,
					videos_panel
				]
			});
			
			
			Ext.EventManager.onWindowResize(function () {
		            
		        });

		}
	});
}



browser = false;
tipo_manual = 'programas';


if (browser) {
	if (tipo_manual == 'programas') {
		programas_data = [	
			{
			    nombre: "Agenda abierta", 
			    imagen_url: "http://media.tlsur.net/programas/agenda-abierta.png", 
			    slug: "agenda-abierta"
			}, 
			{
			    "descripcion": "", 
			    "nombre": "Deportes teleSUR", 
			    "imagen_url": "http://media.tlsur.net/programas/deportes-telesur.png", 
			    "slug": "deportes-telesur"
			}, 
			{
			    "descripcion": "Conducido por el periodista y corresponsal de guerra Walter Martinez, Dossier nos ofrece la información con una óptica propia, los sucesos internacionales y noticias de resonancia mundial en su pleno desarrollo e impacto social.", 
			    "nombre": "Dossier", 
			    "imagen_url": "http://media.tlsur.net/programas/dossier.png", 
			    "slug": "dossier"
			}, 
			{
			    "descripcion": "Programa informativo que combina lo noticioso con el análisis y la opinión,los cuales reflejan la actividad diaria del mundo económico.", 
			    "nombre": "Impacto económico", 
			    "imagen_url": "http://media.tlsur.net/programas/impacto-economico.png", 
			    "slug": "impacto-economico"
			}
		];
		
	}
	else {
		
	}
	
	iniciar(tipo_manual);
}