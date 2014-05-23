require 'spec_helper'

describe LunchDatesController do

  let(:valid_attributes) { { "content" => "MyText" } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all lunch_dates as @lunch_dates" do
      lunch_date = LunchDate.create! valid_attributes
      get :index
      expect(assigns(:lunch_dates)).to eq([lunch_date])
    end
  end

  describe "GET show" do
    it "assigns the requested lunch_date as @lunch_date" do
      lunch_date = LunchDate.create! valid_attributes
      get :show, {:id => lunch_date.to_param}, valid_session
      expect(assigns(:lunch_date)).to eq(lunch_date)
    end
  end

  describe "GET new" do
    it "assigns a new lunch_date as @lunch_date" do
      get :new, {}, valid_session
      expect(assigns(:lunch_date)).to be_a_new(LunchDate)
    end
  end

  describe "GET edit" do
    it "assigns the requested lunch_date as @lunch_date" do
      lunch_date = LunchDate.create! valid_attributes
      get :edit, {:id => lunch_date.to_param}, valid_session
      expect(assigns(:lunch_date)).to eq(lunch_date)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LunchDate" do
        expect {
          post :create, {:lunch_date => valid_attributes}, valid_session
        }.to change(LunchDate, :count).by(1)
      end

      it "assigns a newly created lunch_date as @lunch_date" do
        post :create, {:lunch_date => valid_attributes}, valid_session
        expect(assigns(:lunch_date)).to be_a(LunchDate)
        expect(assigns(:lunch_date)).to be_persisted
      end

      it "redirects to the created lunch_date" do
        post :create, {:lunch_date => valid_attributes}, valid_session
        expect(response).to redirect_to(LunchDate.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lunch_date as @lunch_date" do
        # Trigger the behavior that occurs when invalid params are submitted
        LunchDate.any_instance.stub(:save).and_return(false)
        post :create, {:lunch_date => { "content" => "invalid value" }}, valid_session
        expect(assigns(:lunch_date)).to be_a_new(LunchDate)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LunchDate.any_instance.stub(:save).and_return(false)
        post :create, {:lunch_date => { "content" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lunch_date" do
        lunch_date = LunchDate.create! valid_attributes
        # Assuming there are no other lunch_dates in the database, this
        # specifies that the LunchDate created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(LunchDate).to receive(:update).with({ "content" => "MyText" })
        put :update, {:id => lunch_date.to_param, :lunch_date => { "content" => "MyText" }}, valid_session
      end

      it "assigns the requested lunch_date as @lunch_date" do
        lunch_date = LunchDate.create! valid_attributes
        put :update, {:id => lunch_date.to_param, :lunch_date => valid_attributes}, valid_session
        expect(assigns(:lunch_date)).to eq(lunch_date)
      end

      it "redirects to the lunch_date" do
        lunch_date = LunchDate.create! valid_attributes
        put :update, {:id => lunch_date.to_param, :lunch_date => valid_attributes}, valid_session
        expect(response).to redirect_to(lunch_date)
      end
    end

    describe "with invalid params" do
      it "assigns the lunch_date as @lunch_date" do
        lunch_date = LunchDate.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LunchDate.any_instance.stub(:save).and_return(false)
        put :update, {:id => lunch_date.to_param, :lunch_date => { "content" => "invalid value" }}, valid_session
        expect(assigns(:lunch_date)).to eq(lunch_date)
      end

      it "re-renders the 'edit' template" do
        lunch_date = LunchDate.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LunchDate.any_instance.stub(:save).and_return(false)
        put :update, {:id => lunch_date.to_param, :lunch_date => { "content" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lunch_date" do
      lunch_date = LunchDate.create! valid_attributes
      expect {
        delete :destroy, {:id => lunch_date.to_param}, valid_session
      }.to change(LunchDate, :count).by(-1)
    end

    it "redirects to the lunch_dates list" do
      lunch_date = LunchDate.create! valid_attributes
      delete :destroy, {:id => lunch_date.to_param}, valid_session
      expect(response).to redirect_to(lunch_dates_url)
    end
  end

end
