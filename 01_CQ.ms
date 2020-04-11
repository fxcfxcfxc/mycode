
 content = ""

rollout firstSrcip "SQG-传奇 V1.0-冯晓晨"

(


--------------------------ui------------------------------------------------------
--------------------------ui------------------------------------------------------




    group "渲染角度"
    (
    button firstButton  "回到正面" width:100 height:50  
    button firstButton2 "30度侧面" width:100 height:50
    button firstButton3 "180度背面" width:100 height:50
    )

    group "maya导入设置光滑组"
    (

    button firstButton4 "MAYAkeepCrease1" width:200 height:50
    checkbox x "开启第一组光滑组设置" checked:(true) 
    spinner spinner01 "级别" width:60 range:[0,5,1]  type:#integer
    button firstButton4a "MAYAkeepCrease2" width:200 height:50
    checkbox y "开启第二组光滑组设置" checked:(false)  
    spinner spinner02 "级别" width:60 range:[0,5,1]  type:#integer 
    checkbox z "开启第一组光滑组设置" checked:(true)
    spinner spinner03 "级别" width:60 range:[0,5,2]  type:#integer 
    
    )

    group "替换模型信息"
    (
    button firstButton5 "存储模型信息" width:200 height:50
    button firstButton6 "赋予模型信息" width:200 height:50
    )

    group "批量功能"
    (

      button buttonImp " 批量导入物体(同时支持FBX,obj)" width:200 height:50

      
    )

    
    group "快速存图"
    (
      edittext edit01 "目标"  text: content  fieldWidth: 100 height:25   across:3
      button but1 "选择"  width:50 height:30  align:#right
      button but2 "保存"  width:50 height:30 align:#right
        

    )

--------------------------function------------------------------------------------------
--------------------------function------------------------------------------------------

--1.获取到保存的目标路径i
  --2. 显示i在内容框内
  --3.保存vray图片到i



   function   meshImp  Title FilterName   = 

  ( 
     dialog = dotNetObject "System.Windows.Forms.OpenFileDialog"

    dialog.title = Title
    dialog.filter =  FilterName
    dialog.Multiselect = true

    FileResult = dialog.showDialog()

    if  FileResult.Equals  FileResult.ok  then
      (
        dialog.FileNames 


      )
      else 
        Undefined
  )

  -------------function-上面获取到选择文件的路径和文件名的函数

    function meshRz x =
     (
             
    a = $ 
    if $ != undefined  then ( a.rotation.z_rotation=x) else ( messageBox"请选择一个物体")

    )

    function meshTurbo01  x = 
    
    (
        a = $

               if selection.count==1  then 
               (
                 if a.modifiers.count==1 then 
                 (deleteModifier a 1
                  addModifier a (TurboSmooth sepBySmGroups:x  iterations:spinner01.value )  )
                    else
                        
                      (messageBox "选择一个正确从maya导入有一级修改器的物体")
                                     
                )
 
                 else (messageBox "请选择一个物体" title:"警告")                      
    )

    function meshTurbo02  x y = 
    
    (
        a = $

        if selection.count ==1  then 
        (
          if a.modifiers.count==1 then 
          (deleteModifier a 1
            addModifier a (TurboSmooth sepBySmGroups:x iterations:spinner03.value)
            addModifier a (TurboSmooth sepBySmGroups:y iterations:spinner02.value) 
          )
             else
                 
               (messageBox "选择一个正确从maya导入有一级修改器的物体")
                         
        )

          else (messageBox"请选择一个物体")

    )


    function meshSave = 
    (
        meshf = $

        if selection.count!=0  then 
        (

         global a = meshf.Position
         global b = meshf.rotation
         global c = meshf.scale
        )
        else (messageBox "请选择需要存储信息的模型（选择后可删除）")
    )

    function meshExp =
   
   (

    if selection.count!=0  then 
        (

   meshS = $

   meshS.Position = a
   meshS.rotation = b
   meshS.scale = c
    )
     else (messageBox "请选择需要附加的模型") 

   )


 --------------------------callback------------------------------------------------------
--------------------------callback------------------------------------------------------


on  firstButton pressed do (
  

     meshRz 0
   
)
on  firstButton2 pressed do (
    meshRz 30   
)
on  firstButton3 pressed do (
    meshRz -180
)
on  firstButton4 pressed do (


   meshTurbo01 true   
)
on  firstButton4a pressed do (

    meshTurbo02 true false
   
)
on  firstButton5 pressed do (


meshSave()
    
    
)

on  firstButton6 pressed do (
  

meshExp()
   
    
)

on  buttonImp pressed do (
  

    fileId = meshImp  "选择导入文件"   "FBX (*.fbx)|*.fbx|OBJ (*.obj)|*.obj"

    if fileId != undefined do
      
      ( 
        for f in fileId do
          (
           
            if  getFilenameType f == ".fbx" then  
              (
                importFile f #noPrompt  using:FBXIMP
              )
            else
              (
                importFile f #noPrompt  using:Wavefront_Objec

              )
             ---导入物体

            for geo in geometry
            where (MatchPattern geo.name pattern:"3D_Object*")do ----?
              (
                path= FilterString (f as string)"//"----?
                geo.name = path[path.count]-----?

              )

          )



      )
      
      
  )

global tmpfileNames
  on  but1 pressed do 
    (
  
       tmpfileNames = getOpenFileName () 
  
      if tmpfileNames != undefined do
        (
          
          edit01.text =  tmpfileNames

          --Print tmpfileNames
  
  
  
        )
  
  
    )

    on  but2 pressed do
      
      (

        vfbControl #saveimage  tmpfileNames

         --render outputfile:  tmpfileNames  （可以保存线扫）






      )






)



CreateDialog firstSrcip 300 800
--cui.DockDialogBar firstSrcip #cui_dock_left
--try modPanel.addModToSelection (Extrude ()) ui:off catch()


