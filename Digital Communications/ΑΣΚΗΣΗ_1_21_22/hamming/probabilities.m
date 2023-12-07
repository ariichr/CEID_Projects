function [probabilities,theSum] = probabilities(n)
%PROBABILITIES Summary of this function goes here

     probabilities = rand(1, n);
     probabilities = probabilities / sum(probabilities) ;
     theSum = sum(probabilities);
     
             
     end    
     
     
     
     


