function [sig] = myhuffmandeco(enco,dict,inpuSig)

a=[];
count=1;
sig=cell(1,length(dict));
for i=1:length(enco)
        b=[a enco(i)];
       
        for j=1:length(dict)
            
           if( isequal(b,dict{j,2})&& isequal(inpuSig(count),dict{j,1}))
             
            sig{count}=dict{j,1};
               b=[];
               count=count+1; 
           end
          
        end
         
        a=b;
 
end

