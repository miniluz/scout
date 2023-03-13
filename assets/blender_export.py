import bpy

for object in bpy.data.objects:
    if object.type != "MESH":
        continue
    
    mesh = object.data
    edges = mesh.edges
    
    # 
    
    new_verts = []
    new_edges = []
    new_faces = []
    
    i = 0
    
    for edge in edges:
        vertex1, vertex2 = edge.vertices
        vertex1 = mesh.vertices[vertex1].co
        vertex2 = mesh.vertices[vertex2].co
        print(vertex1, vertex2)
        new_verts.append(vertex1)
        new_verts.append(vertex1)
        new_verts.append(vertex2)
        new_verts.append(vertex2)
        ## 0-1
        ## |/|
        ## 2-3
        new_edges.append([i+0, i+1]) #0-1
        new_edges.append([i+0, i+2]) #0|2
        new_edges.append([i+1, i+2]) #1/2
        new_edges.append([i+1, i+3]) #1|3
        new_edges.append([i+2, i+3]) #2-3
        new_faces.append([i+0, i+1, i+2]) #0-1/2|0
        new_faces.append([i+1, i+2, i+3]) # 1/2-3|1
        i += 4
        
    new_mesh = bpy.data.meshes.new("new_mesh")
    new_mesh.from_pydata(new_verts, new_edges, new_faces)
    
    new_object = bpy.data.objects.new("new_object", new_mesh)
    bpy.context.collection.objects.link(new_object)