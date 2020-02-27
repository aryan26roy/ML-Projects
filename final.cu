#include <algorithm> 
#include <iostream> 
#include <vector>
using namespace std; 
  
typedef std::vector<double> vi; 
  
typedef vector<vector<double> > matrix; 
vi A; 
vi IA = { 0 }; 
vi JA; 
vi DA;
int length;

__global__ void multi(double *a, double *b, double *c, int n){
    int id = blockIdx.x*blockDim.x+threadIdx.x;
    if(id<n){
        c[id] = a[id]*b[id];
    }
    }
    

void printMatrix(const matrix& M) 
{ 
    int m = M.size();
    int n = M[0].size(); 
    for (int i = 0; i < m; i++) { 
        for (int j = 0; j < n; j++)  
            cout << M[i][j] << " ";         
        cout << endl; 
    }

} 
void printlist(double* V, char* msg, int m) 
{   
    cout << msg << "[ "; 
    
    for( int i =0; i<m; i++){ 
        cout << V[i] << " "; 
    }; 
    cout << "]" << endl; 
} 
void copyto(vi& V, double* C, int N){
    // cout<<"yo"<<std::endl;
    //
     //cout<<N<<std::endl;+-
    for(int i =0; i<=N-1; i++)
    std::copy(V.begin(), V.end(), C);
    //}
    //free(C);
}
void printVector(const vi& V, char* msg) 
{ 
  
    cout << msg << "[ "; 
    for_each(V.begin(), V.end(), [](double a) { 
        cout << a << " "; 
    }); 
    cout << "]" << endl; 
} 
void decirculate( vi& JA, const matrix& M, const vi& IA){

    int rows = M[0].size();
    int itr = IA.size();
    rows = rows-1;
    int i,j;
    for(i=0; i<itr-1; i++){
        for(j=IA[i];j<IA[i+1];j++){
            if(JA[j]<i){
                JA[j] = rows - (i-JA[j]-1);
            }
            else{
                JA[j] = JA[j]-i;

            }
        }
    }
    //return JA;
}
void extendVec(vi& A,int num,int size){
for(int i = 0; i<=num; i++){
cout<<num<<std::endl;
    for (int j =0; j<size; j++ ){
    A.push_back(A[j]);
    }
}
    
}
void createdense(matrix& CA, vi& JA){
    int m = JA.size();
    int n = CA[0].size();
    for(int i =0; i<n; i++){
        for(int k =0; k<m; k++){
        DA.push_back(CA[JA[k]][i]); } 
    }
    }


void sparesify(const matrix& M) 
{ 
    int m = M.size(); 
    int n = M[0].size(), i, j; 
    
    int dab = 0; 
  
    for (i = 0; i < m; i++) { 
        for (j = 0; j < n; j++) { 
            if (M[i][j] != 0) { 
                A.push_back(M[i][j]); 
                JA.push_back(j); 
  
               
                dab++; 
            } 
        }
       
        IA.push_back(dab); 
    } 
    decirculate(JA,M,IA); 
    printMatrix(M);
    cout<<"++++++++++++++++++++++++++++++++++++++++++"<<std::endl; 
    printVector(A, (char*)"A = "); 
    printVector(IA, (char*)"IA = "); 
    printVector(JA, (char*)"JA = ");
    cout<<"++++++++++++++++++++++++++++++++++++++++++"<<std::endl; 
} 
  

int main() 

{
    double *IN,*in; 
    double *OUT,*out;
    double *ANS,*ans;
     
     matrix M = { 
        { 0, 0, 0, 0, 1 }, 
        { 5, 8, 0, 0, 0 }, 
        { 0, 0, 3, 0, 0 }, 
        { 0, 6, 0, 0, 1 }, 
        };
        matrix CA = {{1,1,1,1,1},
    {2,2,2,2,2},
    {3,3,3,3,3},
    {4,4,4,4,4},
    {5,5,5,5,5}};
    sparesify(M);
        createdense(CA,JA); 
    extendVec(A,DA.size()/A.size(),A.size());
    cout<<DA.size()<<std::endl;
    length = DA.size();
    int size = length*sizeof(double);
        cout<<size<<std::endl;
    int gridsize;
    cudaMalloc((void **) &in, size);
    cudaMalloc((void **) &out, size);
    cudaMalloc((void **) &ans, size);
    IN = (double *)malloc(size);
    OUT = (double *)malloc(size);
    ANS = (double *)malloc(size);
    cudaMalloc((void **) &in, size);
    cudaMalloc((void **) &out, size);
    cudaMalloc((void **) &ans, size);

        printVector(DA, (char*)"DA = ");
    copyto(DA,&IN[0],DA.size());
    copyto(A,&OUT[0],DA.size());
    printlist(&OUT[0], (char*)"Out = ",DA.size());
    printlist(&IN[0], (char*)"IN = ",DA.size()); 
    cout<<"++++++++++++++++++++++++++++++++++++++++++"<<std::endl;
    gridsize =ceil(size/1024);
    gridsize = 32;
    cudaMemcpy(in, IN, size, cudaMemcpyHostToDevice);
    cudaMemcpy(out,OUT, size, cudaMemcpyHostToDevice);
    multi<<<32,1024>>>(in,out,ans,DA.size());
    cudaMemcpy(ANS, ans, size, cudaMemcpyDeviceToHost);
    printlist(&ANS[0], (char*)"ANS = ",DA.size()); 
    free (IN); free(OUT); free(ANS);
    cudaFree(in); cudaFree(out); cudaFree(ans);
    return 0; 
} 
