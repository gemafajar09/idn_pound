var html = ""
var dataList = {}
$(document).ready(function(){
    $('#body').hide()
    $('#pound').hide()
})

let IDR = new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
});


window.addEventListener('message', function (event) {
    var item = event.data
    if (item.type === "samsat") {
        if (item.status == true) {
            var currentDate = new Date().toJSON().slice(0, 10)
            $('#tglMasuk').val(currentDate)
            $('#body').show()
        } else {
            $('#body').hide()
        }
    }else if(item.type === "kendaraan"){
        if (item.status == true) {
            $('#pound').show()
            
            dataList =  item.list
            for (i = 0; i < dataList.length; i++){
                
                html += '<div class="p-3 border rounded-lg shadow-lg">'+
                                    '<div class="flex items-center justify-between mb-2">'+
                                        '<p class="text-sm font-bold">'+ dataList[i].firstname +' '+ dataList[i].lastname +'</p>'+
                                        '<p class="text-sm font-bold">'+ dataList[i].plate +'</p>'+
                                    '</div>'+
                                    '<div class="flex items-center text-xs justify-between mb-1">'+
                                        '<p class="">Tanggal Sita </p>'+
                                        '<p>'+ dataList[i].tgl_masuk +'</p>'+
                                    '</div>'+
                                    '<div class="flex items-center text-xs justify-between mb-1">'+
                                        '<p>Tanggal Keluar</p>'+
                                        '<p>'+ dataList[i].tgl_keluar +'</p>'+
                                    '</div>'+
                                    '<div class="flex items-center text-xs justify-between mb-1">'+
                                        '<p>Denda</p>'+
                                        '<p>'+ IDR.format(dataList[i].denda) +'</p>'+
                                    '</div>'+
                                    '<div class="flex items-center text-xs justify-between mb-1">'+
                                        '<p class="pr-4">Catatan</p>'+
                                        '<p>'+ dataList[i].catatan +'</p>'+
                                    '</div>'+
                                    '<div class="flex items-center justify-end">'+
                                        '<button class="bg-blue-400 hover:bg-blue-600 text-white p-2 rounded-md" type="button" onclick="getkendaraan('+ parseInt(i) +')">Keluarkan</button>'+
                                    '</div>'+
                                '</div>'
            }

            $('#isidata').html(html)
        } else {
            $('#pound').hide()
        }
    }
})

function sitakendaraan() {
    var tglMasuk = $("#tglMasuk").val()
    var tglKeluar = $("#tglKeluar").val()
    var denda = $("#denda").val()
    var catatan = $("#catatan").val()
    if (tglMasuk == null){
       console.log(1)
    }else if( tglKeluar == null){
        console.log(2)
    }else if(denda == null){
        console.log(3)
    }else if(catatan == null) {
        console.log(4)
    }else{
        $.post('http://idn_pound/simpan', JSON.stringify({
            tglMasuk: tglMasuk,
            tglKeluar: tglKeluar,
            denda: denda,
            catatan: catatan,
          })
        );
    }

    return;
}

function getkendaraan(i){
    	
    	$.post('http://idn_pound/ambilkendaraan', JSON.stringify({
            owner: dataList[i].owner,
            plate: dataList[i].plate
          })
        );
    	
        $('#body').hide()
    	$('#pound').hide()
        $.post('http://idn_pound/exit')
    	
    	return;
}

$(document).keyup(function(e) {
	if (e.keyCode === 27) {
        html = ""
        $('#body').hide()
    	$('#pound').hide()
        $.post('http://idn_pound/exit')
    }
});
