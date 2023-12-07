function getcodes(a,code)

global dict
global helper

if isa(a,'cell')
         getcodes(a{1},[code 1]);
        
         getcodes(a{2},[code 0]);
else 
    
       for i=1:length(helper)
         if(a==dict{i,1})
         dict{i,2}=code;
         end
       end  
end
end
