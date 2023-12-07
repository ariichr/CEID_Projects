function [enco] = myhuffmanenco(inputSig,dict)


    b=[];
   
    
    
     for i=1:length(inputSig)
        for j=1:length(dict)
           if( strcmpi(inputSig(i),dict{j,1}))
               enco=[b dict{j,2}];
               b=enco;
            end
        end
     end
    end   
   
   



