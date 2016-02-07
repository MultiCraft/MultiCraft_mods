-- Watch recipe
minetest.register_craft({
  description = "Watch",
  output = 'watch:watch',
  recipe = {
    {'', 'default:gold_ingot', ''},
    {'default:gold_ingot', 'default:bluestone_dust', 'default:gold_ingot'},
    {'', 'default:gold_ingot', ''}
  }
})


--Watch tool
watch.registra_item("watch:watch",watch.images_a[3],true)

--Faces
for a=0,11,1 do
  watch.registra_item("watch:watch_a"..tostring(a),watch.images_a[a+1],false)
end
