function [dict,avglen]=myhuffmandict(s,p)
      c=cell(1,length(p));
      n=length(p)-2;
      global dict
      global helper
      dict=cell(length(p),2); %δημιουργια cell
      phelper=p;   
      for i=1:length(p)  % αποθηκευση συμβολων και πιθανοτητων
         dict{i,1}=s(i);
         dict{i,2}=p(i);
          				
      end
      dict = sortrows(dict,[2]); %ταξινομηση
     
      for i=1:length(p) %ξαναβαζω σωστα ταξινομημενες τις πιθανοτητες
      p(i)=dict{i,2};
     end
     
     
     for i=1:length(p) %αρχικοποιω το "δεντρο μου"         
          c{i}=dict{i,1};					
     end
     helper=c;
     
     for k=1:n	
     	
        c{2}={c{1},c{2}};
         c(1)=[];	
         
	    p(2)=p(1)+p(2);
        p(1)=[];	
        [~,i]=sort(p); %ταξινομηση
        c=c(i);	
     end    
      
       getcodes(c,[]);
       avglen=0; %υπολογισμος μηκους με βαση τις πιθανοτητες
       phelper=sort(phelper);
       for w=1:length(phelper)
         len= size(dict{w,2});
         avglen = avglen +( len(2)*phelper(w));
       end    
      
end